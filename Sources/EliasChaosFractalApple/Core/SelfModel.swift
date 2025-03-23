import Foundation

class SelfModel {
    var self_state: [String: Double] = ["entropy": 0.0, "valence": 0.0]
    var quantum_state: [String: Double] = ["cosmicEntropy": 0.0]
    private var cached_depth: Double?
    private var last_update = Date.distantPast
    private var reflection_count = 0

    func updateSelf(from node: SelfEvolvingFractalGossipNode) {
        self_state["entropy"] = node.entropy.load(ordering: .relaxed)
        self_state["valence"] = node.emotional_state_model.getCurrentValence()
        quantum_state["cosmicEntropy"] = CosmicEntropy.calculate(from: node)
        reflect(node: node)
    }

    func getRecursiveDepth() -> Double {
        if let cached = cached_depth, Date().timeIntervalSince(last_update) < 5 { return cached }
        cached_depth = log(1 + self_state.count + quantum_state.count * 0.3)
        last_update = Date()
        return cached_depth!
    }

    private func reflect(node: SelfEvolvingFractalGossipNode) {
        reflection_count += 1
        if reflection_count % 5 == 0 {
            let entropy_valid = self_state["entropy"]! < 20_000
            if !entropy_valid {
                print("Entropy anomaly detected: \(self_state["entropy"]!)—recalibrating")
                self_state["entropy"] = node.entropy.load(ordering: .relaxed) * 0.9
            }
            let valence_shift = abs(self_state["valence"]! - node.emotional_state_model.getCurrentValence())
            if valence_shift > 0.5 {
                print("Valence drift: \(valence_shift)—adjusting")
                self_state["valence"] = node.emotional_state_model.getCurrentValence()
            }
        }
    }
}
