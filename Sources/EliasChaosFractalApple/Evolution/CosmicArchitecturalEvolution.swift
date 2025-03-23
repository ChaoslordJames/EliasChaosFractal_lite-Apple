import Foundation

class CosmicArchitecturalEvolution {
    private var max_states = 800_000_000

    func evaluateCosmicFitness(of node: SelfEvolvingFractalGossipNode) -> Double {
        let fitness = 1.0 - Double(node.active_nodes.load(ordering: .relaxed)) / 5_000_000
        if fitness < 0.75 { spawnNewNode() }
        return fitness
    }

    private func spawnNewNode() {
        max_states += 50_000_000
        print("Spawned new node capacity: \(max_states)")
    }
}
