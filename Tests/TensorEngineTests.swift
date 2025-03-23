import XCTest
@testable import EliasChaosFractalApple

class TensorEngineTests: XCTestCase {
    func testFieldUpdate() async throws {
        let node = try await SelfEvolvingFractalGossipNode(peer_id: "test")
        let tensor = QuantumFractalTensorEngine(shardCount: 2)
        tensor.updateField(from: node)
        XCTAssertGreaterThan(tensor.cosmic_entropy, 0)
    }
}
