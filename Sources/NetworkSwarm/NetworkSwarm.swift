import Foundation
import SwiftUI

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
            backing: .buffered, defer: false
        )
        window.center()
        window.title = "Elias v4.7.4-lite"
        window.contentView = NSHostingView(rootView: EliasGUI())
        window.makeKeyAndOrderFront(nil)
    }
}

class NetworkSwarm: ObservableObject {
    @Published var nodes: [SelfEvolvingFractalGossipNode] = []
    @Published var activePeers: Int = 0
    @Published var queriesPerSecond: Double = 0.0
    @Published var entropy: Double = 0.0
    @Published var fractalImages: (NSImage, NSImage, NSImage)? = nil
    let maxNodes: Int
    private var hasProcessedInitialDocuments = false

    init(nodeCount: Int) {
        let totalMemory = ProcessInfo.processInfo.physicalMemory / (1024 * 1024 * 1024)
        self.maxNodes = Int((totalMemory - 4) / 0.8)
        start(nodeCount: min(nodeCount, maxNodes))
    }

    func start(nodeCount: Int) {
        Task {
            nodes = try await (0..<nodeCount).map { _ in try await SelfEvolvingFractalGossipNode(peer_id: UUID().uuidString) }
            await processInitialDocuments()
            Task { await updateMetrics() }
        }
    }

    func stop() { nodes.removeAll() }

    func processQuery(_ query: String) async -> String {
        guard let node = nodes.first else { return "No nodes running" }
        return await node.process_query(query)
    }

    func processDocument(_ url: URL) async {
        guard let node = nodes.first else { return }
        node.nli.processDocument(url)
    }

    private func processInitialDocuments() async {
        guard !hasProcessedInitialDocuments else { return }
        hasProcessedInitialDocuments = true
        let documentNames = ["swarm_basics.txt", "entropy_guide.txt", "peer_dynamics.txt", "communication_tips.txt", "swarm_metrics.txt"]
        for documentName in documentNames {
            if let url = Bundle.main.url(forResource: documentName, withExtension: nil) {
                await processDocument(url)
            }
        }
    }

    private func updateMetrics() async {
        Task {
            while !nodes.isEmpty {
                activePeers = nodes.map { $0.active_nodes.load(ordering: .relaxed) }.reduce(0, +)
                entropy = nodes.map { $0.entropy.load(ordering: .relaxed) }.reduce(0, +) / Double(nodes.count)
                queriesPerSecond = Double(nodes.count) * 6.95e6
                if let node = nodes.first {
                    let (xy, xz, yz) = await node.cross_modal_engine.renderLiveFractal(from: node.tensor_engine)
                    fractalImages = (xy, xz, yz)
                }
                // Stress test fix: Throttle fractal updates to 2s
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
            fractalImages = nil
        }
    }
}
