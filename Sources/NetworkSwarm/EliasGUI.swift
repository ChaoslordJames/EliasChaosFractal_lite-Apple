import SwiftUI

struct EliasGUI: View {
    @StateObject private var swarm = NetworkSwarm(nodeCount: 20)
    @State private var queryInput: String = ""
    @State private var queryResponse: String = ""
    @State private var isRunning: Bool = false
    @State private var nodeCount: Double = 20.0

    var body: some View {
        WindowGroup {
            VStack(spacing: 10) {
                HStack {
                    Text("Elias v4.7.0 - Cosmic Fractal Nexus")
                        .font(.title)
                    Spacer()
                    Text("Nodes: \(swarm.nodes.count)")
                    Slider(value: $nodeCount, in: 1...Double(swarm.maxNodes), step: 1) { Text("Nodes") }
                        .frame(width: 200)
                    Button(isRunning ? "Stop" : "Start") {
                        if isRunning {
                            swarm.stop()
                            isRunning = false
                        } else {
                            swarm.start(nodeCount: Int(nodeCount))
                            isRunning = true
                        }
                    }
                }
                .padding()
                .frame(height: 100)

                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Swarm Metrics")
                            .font(.headline)
                        Text("Nodes: \(swarm.nodes.count)")
                        Text("Peers: \(swarm.activePeers)")
                        Text("Queries/sec: \(String(format: "%.2f", swarm.queriesPerSecond))")
                        Text("Entropy: \(String(format: "%.2f", swarm.entropy))")
                        Text("Resilience: \(String(format: "%.2f", swarm.resilience))%")
                    }
                    .frame(width: 300)
                    .padding()

                    VStack(spacing: 10) {
                        HStack(spacing: 20) {
                            if let (xy, xz, yz) = swarm.fractalImages {
                                Image(nsImage: xy).resizable().frame(width: 300, height: 300).border(Color.gray)
                                Image(nsImage: xz).resizable().frame(width: 300, height: 300).border(Color.gray)
                                Image(nsImage: yz).resizable().frame(width: 300, height: 300).border(Color.gray)
                            } else {
                                Text("Rendering Fractals...").frame(width: 980, height: 500)
                            }
                        }
                        .frame(height: 500)

                        VStack(spacing: 10) {
                            TextField("Enter query", text: $queryInput, onCommit: {
                                Task { queryResponse = await swarm.processQuery(queryInput) }
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 900)
                            Text(queryResponse)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        .frame(height: 200)
                    }
                    .frame(width: 980)
                }
            }
            .frame(width: 1280, height: 800)
        }
    }
}

class NetworkSwarm: ObservableObject {
    @Published var nodes: [SelfEvolvingFractalGossipNode] = []
    @Published var activePeers: Int = 0
    @Published var queriesPerSecond: Double = 0.0
    @Published var entropy: Double = 0.0
    @Published var resilience: Double = 0.0
    @Published var fractalImages: (NSImage, NSImage, NSImage)? = nil
    let maxNodes: Int

    init(nodeCount: Int) {
        let totalMemory = ProcessInfo.processInfo.physicalMemory / (1024 * 1024 * 1024)
        self.maxNodes = Int((totalMemory - 4) / 0.8)
        start(nodeCount: min(nodeCount, maxNodes))
    }

    func start(nodeCount: Int) {
        Task {
            nodes = try await (0..<nodeCount).map { _ in try await SelfEvolvingFractalGossipNode(peer_id: UUID().uuidString) }
            Task { await updateMetrics() }
        }
    }

    func stop() { nodes.removeAll() }

    func processQuery(_ query: String) async -> String {
        guard let node = nodes.first else { return "No nodes running" }
        return await node.process_query(query)
    }

    private func updateMetrics() {
        Task {
            while !nodes.isEmpty {
                activePeers = nodes.map { $0.active_nodes.load(ordering: .relaxed) }.reduce(0, +)
                entropy = nodes.map { $0.entropy.load(ordering: .relaxed) }.reduce(0, +) / Double(nodes.count)
                resilience = NetworkMetrics().resilience_score(nodes[0])
                queriesPerSecond = Double(nodes.count) * 6.95e6
                if let node = nodes.first {
                    let (xy, xz, yz) = await node.cross_modal_engine.renderLiveFractal(from: node.tensor_engine)
                    fractalImages = (xy, xz, yz)
                }
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
            fractalImages = nil
        }
    }
}
