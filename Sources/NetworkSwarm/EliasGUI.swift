import SwiftUI

struct EliasGUI: View {
    @StateObject private var swarm = NetworkSwarm(nodeCount: 20)
    @State private var queryInput: String = ""
    @State private var queryResponse: String = ""
    @State private var isRunning: Bool = false
    @State private var showFilePicker: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Elias v4.7.4-lite - Fractal Nexus")
                    .font(.title)
                Spacer()
                Text("Nodes: \(swarm.nodes.count)")
                Button(isRunning ? "Stop" : "Start") {
                    if isRunning { swarm.stop(); isRunning = false }
                    else { swarm.start(nodeCount: 20); isRunning = true }
                }
                Button("Upload Document") { showFilePicker = true }
                    .fileImporter(
                        isPresented: $showFilePicker,
                        allowedContentTypes: [.text, .pdf],
                        allowsMultipleSelection: false
                    ) { result in
                        switch result {
                        case .success(let urls):
                            if let url = urls.first {
                                Task { await swarm.processDocument(url) }
                            }
                        case .failure(let error):
                            queryResponse = "Failed to upload document: \(error.localizedDescription)"
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
            .frame(width: 1280, height: 800)
        }
    }
}
