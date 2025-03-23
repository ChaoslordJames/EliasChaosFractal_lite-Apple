import Foundation

class Resolver {
    private let node: SelfEvolvingFractalGossipNode
    private var resolution_threshold: Double = 0.01 // 1% entropy stability
    private var last_entropy: Double = 0.0

    init(node: SelfEvolvingFractalGossipNode) { self.node = node }

    func should_resolve() -> Bool {
        let current_entropy = node.entropy.load(ordering: .relaxed)
        let delta = abs(current_entropy - last_entropy) / current_entropy
        last_entropy = current_entropy
        return delta < resolution_threshold && current_entropy < 20_000
    }

    func collapse_and_seed() async {
        print("Collapsing wave—entropy stabilized at \(last_entropy)")
        let refined_state = State(cid: UUID().uuidString, encrypted: "Resolved: \(last_entropy)", peers: node.peers)
        node.state_manager.saveState(refined_state)
        await node.redis.cache_state(refined_state)
        node.chaos_history = [[last_entropy]]
    }
}
