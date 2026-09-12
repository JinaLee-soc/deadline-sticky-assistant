import Foundation
@main struct Checks {
    static func main() throws {
        let live = CommandLine.arguments.contains("--live")
        let chat = CodexChat()
        let request:[String:Any] = ["snapshot":["today":"2026-09-12","language":"en","projects":[["name":"Synthetic interview study","remaining":1,"stages":[["name":"Interview outline","status":"unfinished"]]]]],"history":[],"question":"What should I do next? One sentence. This is a synthetic connection test."]
        if live {
            var done=false,ok=false
            chat.start(request) { result in print(result);ok=result["ok"] as? Bool == true;done=true }
            while !done { RunLoop.main.run(until:Date().addingTimeInterval(0.05)) }
            exit(ok ? 0:1)
        }
        let fake=URL(fileURLWithPath:FileManager.default.currentDirectoryPath).appendingPathComponent("tests/fake-codex.py")
        for (mode,expected) in [("success",""),("apikey","loginRequired"),("mcp","unsafeTools"),("approval","unsafeTools"),("tool","unsafeTools"),("failed","chatError"),("timeout","timeout"),("cancel","cancelled")] {
            try mode.write(to:fake.appendingPathExtension("mode"),atomically:true,encoding:.utf8)
            var done=false
            chat.start(request,binary:fake,timeout:mode=="timeout" ? 0.2:5) { result in
                if expected.isEmpty { precondition(result["ok"] as? Bool == true) }
                else { precondition(result["error"] as? String == expected,"\(mode): \(result)") }
                done=true
            }
            if mode=="cancel" { chat.cancel() }
            while !done { RunLoop.main.run(until:Date().addingTimeInterval(0.02)) }
            precondition(chat.process==nil);print("PASS: \(mode)")
        }
        try? FileManager.default.removeItem(at:fake.appendingPathExtension("mode"))
    }
}
