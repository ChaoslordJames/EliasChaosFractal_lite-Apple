import Foundation

@main
struct NetworkSwarmApp {
    static func main() async throws {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1280, height: 800),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Elias v4.7.0"
        window.contentView = NSHostingView(rootView: EliasGUI())
        window.makeKeyAndOrderFront(nil)
    }
}
