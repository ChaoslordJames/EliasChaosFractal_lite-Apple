import Foundation

class NetworkMetrics {
    func resilience_score(_ node: SelfEvolvingFractalGossipNode) -> Double {
        let peer_count = Double(node.active_nodes.load(ordering: .relaxed))
        let score = min(peer_count / 5_000_000 * 100, 99.99)
        if score < 99.95 { print("Warning: Resilience dropping: \(score)%") }
        return score
    }

    func throughput(_ node: SelfEvolvingFractalGossipNode, queries: Int, seconds: Double) -> Double {
        return Double(queries) / seconds
    }
}
