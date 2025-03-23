import Foundation

class CosmicEntropy {
    static func calculate(from node: SelfEvolvingFractalGossipNode) -> Double {
        let chaos_sum = node.chaos_history.last?.reduce(0, +) ?? 0.0
        let peer_factor = log2(Double(node.active_nodes.load(ordering: .relaxed)) + 1)
        return chaos_sum * peer_factor
    }
}
