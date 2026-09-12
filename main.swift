import AppKit
import WebKit

final class App: NSObject, NSApplicationDelegate, WKScriptMessageHandler, WKNavigationDelegate {
    var window: NSWindow!
    var web: WKWebView!
    var mini: NSPanel!
    var miniWeb: WKWebView!
    let chat = CodexChat()
    var initial: Any = NSNull()
    var startupError = ""
    #if RESEARCH_DESK_QA
    let directory = URL(fileURLWithPath:"/private/tmp/research-desk-share-qa",isDirectory:true)
    #else
    let directory = ProcessInfo.processInfo.environment["RESEARCH_DESK_SHARE_DATA"].map { URL(fileURLWithPath:$0,isDirectory:true) } ?? FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("Research Desk Share", isDirectory: true)
    #endif
    var file: URL { directory.appendingPathComponent("desk.json") }
    func applicationDidFinishLaunching(_ notification: Notification) {
        if FileManager.default.fileExists(atPath: file.path) {
            do { initial = try JSONSerialization.jsonObject(with: Data(contentsOf: file)) }
            catch { startupError = "Saved data could not be read. Existing data has not been overwritten. / 저장 데이터를 읽지 못했어요. 원본은 보존했어요." }
        }
        let config = WKWebViewConfiguration()
        config.userContentController.add(self, name: "desk")
        web = WKWebView(frame: .zero, configuration: config)
        web.navigationDelegate = self
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1080, height: 760), styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: false)
        window.title = "Research Desk"
        window.isReleasedWhenClosed = false
        window.minSize = NSSize(width: 560, height: 480)
        window.contentView = web
        window.center(); window.makeKeyAndOrderFront(nil)
        window.setFrameAutosaveName("ResearchDeskMain")
        let miniConfig = WKWebViewConfiguration(); miniConfig.userContentController.add(self,name:"desk")
        miniWeb = WKWebView(frame:.zero,configuration:miniConfig); miniWeb.navigationDelegate = self
        mini = NSPanel(contentRect:NSRect(x:0,y:0,width:340,height:490),styleMask:[.titled,.closable,.resizable,.nonactivatingPanel],backing:.buffered,defer:false)
        mini.title = "Research Desk"; mini.contentView = miniWeb; mini.minSize = NSSize(width:300,height:320)
        mini.level = .floating; mini.hidesOnDeactivate = false; mini.isReleasedWhenClosed = false
        mini.collectionBehavior = [.canJoinAllSpaces,.fullScreenAuxiliary]
        mini.setFrameAutosaveName("ResearchDeskMini")
        if !mini.setFrameUsingName("ResearchDeskMini"), let screen = NSScreen.main { mini.setFrameOrigin(NSPoint(x:screen.visibleFrame.maxX-360,y:screen.visibleFrame.maxY-540)) }
        if let url = Bundle.main.url(forResource:"mini",withExtension:"html") { miniWeb.loadFileURL(url,allowingReadAccessTo:url.deletingLastPathComponent()) }
        mini.orderFrontRegardless()
        let menu = NSMenu(); let item = NSMenuItem(); let appMenu = NSMenu()
        appMenu.addItem(withTitle:"Open desk / 전체 책상",action:#selector(openDesk),keyEquivalent:"1").target = self
        appMenu.addItem(withTitle:"Small window / 작은 창",action:#selector(toggleMini),keyEquivalent:"2").target = self
        appMenu.addItem(withTitle: "Quit / 종료", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        item.submenu = appMenu; menu.addItem(item)
        let editItem = NSMenuItem(), editMenu = NSMenu(title:"Edit / 편집")
        for (title, action, key) in [("Undo / 실행 취소","undo:","z"),("Cut / 잘라내기","cut:","x"),("Copy / 복사","copy:","c"),("Paste / 붙여넣기","paste:","v"),("Select All / 전체 선택","selectAll:","a")] {
            editMenu.addItem(withTitle:title,action:NSSelectorFromString(action),keyEquivalent:key)
        }
        editItem.submenu = editMenu; menu.addItem(editItem)
        let windowItem = NSMenuItem(), windowMenu = NSMenu(title:"Window / 윈도우")
        windowMenu.addItem(withTitle:"Close / 닫기",action:#selector(NSWindow.performClose(_:)),keyEquivalent:"w")
        windowItem.submenu = windowMenu; menu.addItem(windowItem); NSApp.mainMenu = menu
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") { web.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent()) }
        NSApp.activate(ignoringOtherApps: true)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let args = CommandLine.arguments
        var language = ""
        if let i = args.firstIndex(of: "--language"), args.count > i + 1, ["en", "ko"].contains(args[i + 1]) { language = args[i + 1] }
        let payload: [String: Any] = ["state": initial, "language": language, "error": startupError]
        if let data = try? JSONSerialization.data(withJSONObject: payload), let json = String(data: data, encoding: .utf8) { webView.evaluateJavaScript("window.boot(\(json))") }
    }
    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let allowed = action.request.url?.isFileURL == true && action.request.url!.resolvingSymlinksInPath().standardizedFileURL.path.hasPrefix(Bundle.main.resourceURL!.resolvingSymlinksInPath().standardizedFileURL.path + "/")
        decisionHandler(allowed ? .allow : .cancel)
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.frameInfo.isMainFrame, let body = message.body as? [String:Any] else { return }
        if let action = body["action"] as? String {
            if action == "openDesk" { openDesk(); return }
            if action == "mini" { toggleMini(); return }
            guard message.webView === web, startupError.isEmpty else { return }
            if action == "cancelChat" { chat.cancel(); return }
            if action == "chat", let request = body["request"] as? [String:Any], let requestID = body["requestID"] as? String {
                guard chat.process == nil else { return }
                let ko = (initial as? [String:Any])?["language"] as? String == "ko"
                if !UserDefaults.standard.bool(forKey:"codexChatConsent") {
                    let alert = NSAlert()
                    alert.messageText = ko ? "내 Codex로 대화하기" : "Chat with your Codex"
                    alert.informativeText = ko ? "보내기를 누르면 프로젝트·단계·할 일·마감과 최근 12개 메시지를 Codex 서비스로 전송해요. 이 Mac의 Codex ChatGPT 로그인과 기본 모델을 사용하며 계정 사용량 한도가 적용돼요. 답변은 책상의 기록을 바꾸지 않아요. 대화는 이 Mac에 저장돼요." : "Sending shares your projects, stages, tasks, deadlines and last 12 messages with the Codex service. Uses this Mac’s Codex ChatGPT login and default model, subject to your account limits. Replies do not change desk records. Conversation is saved on this Mac."
                    alert.addButton(withTitle:ko ? "연결하고 보내기" : "Connect and send"); alert.addButton(withTitle:ko ? "취소" : "Cancel")
                    guard alert.runModal() == .alertFirstButtonReturn else { deliverChat(["ok":false,"error":"cancelled","requestID":requestID]); return }
                    UserDefaults.standard.set(true,forKey:"codexChatConsent")
                }
                chat.start(request) { [weak self] result in var response = result; response["requestID"] = requestID; self?.deliverChat(response) }
            }
            return
        }
        guard message.webView === web, startupError.isEmpty, body["version"] as? Int == 2 else { return }
        do {
            let data = try JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted, .sortedKeys])
            guard data.count < 5_000_000 else { throw NSError(domain: "Desk", code: 1) }
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o700])
            if FileManager.default.fileExists(atPath: file.path) { try Data(contentsOf: file).write(to: directory.appendingPathComponent("desk.previous.json"), options: .atomic) }
            try data.write(to: file, options: .atomic)
            try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: file.path)
            initial = body
            web.evaluateJavaScript("window.saved(true)")
            syncMini()
        } catch { web.evaluateJavaScript("window.saved(false)") }
    }
    func deliverChat(_ result: [String:Any]) {
        if let data = try? JSONSerialization.data(withJSONObject:result), let json = String(data:data,encoding:.utf8) { web.evaluateJavaScript("window.chatResult(\(json))") }
    }
    func syncMini() {
        let payload:[String:Any] = ["state":initial,"error":startupError]
        if let data = try? JSONSerialization.data(withJSONObject:payload), let json = String(data:data,encoding:.utf8) { miniWeb.evaluateJavaScript("window.boot(\(json))") }
    }
    @objc func openDesk() { window.makeKeyAndOrderFront(nil); NSApp.activate(ignoringOtherApps:true) }
    @objc func toggleMini() { if mini.isVisible { mini.orderOut(nil) } else { syncMini(); mini.makeKeyAndOrderFront(nil) } }
    func applicationShouldHandleReopen(_ sender:NSApplication,hasVisibleWindows:Bool)->Bool { openDesk(); return true }
    func applicationWillTerminate(_ notification:Notification) { chat.cancel() }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { !window.isVisible && !mini.isVisible }
}
let app = NSApplication.shared
let delegate = App()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
