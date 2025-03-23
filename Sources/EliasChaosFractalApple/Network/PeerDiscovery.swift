import Network

class PeerDiscovery {
    private static var peers: [String] = ["seed1.example.com:8080"]
    private static let udp = NWConnection(host: "255.255.255.255", port: 12345, using: .udp)

    static func get_peers(_ node: SelfEvolvingFractalGossipNode) async -> [String] {
        let cores = ProcessInfo.processInfo.processorCount
        let count = min(node.active_nodes.load(ordering: .relaxed), cores * 500)
        udp.send(content: "DISCOVER".data(using: .utf8), completion: .contentProcessed({ _ in }))
        return Array(peers.prefix(count))
    }

    static func update_peers(_ new_peers: [String]) {
        let cores = ProcessInfo.processInfo.processorCount
        let max_peers = cores * 1000
        peers.append(contentsOf: new_peers.filter { !peers.contains($0) })
        if peers.count > max_peers { peers = Array(peers.suffix(max_peers)) }
    }
}
