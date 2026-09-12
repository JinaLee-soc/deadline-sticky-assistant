import AppKit
import WebKit

final class App: NSObject, NSApplicationDelegate, WKScriptMessageHandler, WKNavigationDelegate {
    var window: NSWindow!
    var web: WKWebView!
    var initial: Any = NSNull()
    var startupError = ""
    let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("Research Desk Share", isDirectory: true)
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
        window.minSize = NSSize(width: 560, height: 480)
        window.contentView = web
        window.center(); window.makeKeyAndOrderFront(nil)
        let menu = NSMenu(); let item = NSMenuItem(); let appMenu = NSMenu()
        appMenu.addItem(withTitle: "Quit / 종료", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        item.submenu = appMenu; menu.addItem(item); NSApp.mainMenu = menu
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") { web.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent()) }
        NSApp.activate(ignoringOtherApps: true)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let args = CommandLine.arguments
        var language = ""
        if let i = args.firstIndex(of: "--language"), args.count > i + 1, ["en", "ko"].contains(args[i + 1]) { language = args[i + 1] }
        let payload: [String: Any] = ["state": initial, "language": language, "error": startupError]
        if let data = try? JSONSerialization.data(withJSONObject: payload), let json = String(data: data, encoding: .utf8) { web.evaluateJavaScript("window.boot(\(json))") }
    }
    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let allowed = action.request.url?.isFileURL == true && action.request.url!.standardizedFileURL.path.hasPrefix(Bundle.main.resourceURL!.path + "/")
        decisionHandler(allowed ? .allow : .cancel)
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.frameInfo.isMainFrame, startupError.isEmpty, let body = message.body as? [String: Any], body["version"] as? Int == 1 else { return }
        do {
            let data = try JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted, .sortedKeys])
            guard data.count < 5_000_000 else { throw NSError(domain: "Desk", code: 1) }
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o700])
            if FileManager.default.fileExists(atPath: file.path) { try Data(contentsOf: file).write(to: directory.appendingPathComponent("desk.previous.json"), options: .atomic) }
            try data.write(to: file, options: .atomic)
            try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: file.path)
            web.evaluateJavaScript("window.saved(true)")
        } catch { web.evaluateJavaScript("window.saved(false)") }
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}
let app = NSApplication.shared
let delegate = App()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
