import XCTest
@testable import EliasChaosFractalApple

class SelfModelTests: XCTestCase {
    func testRecursiveDepth() async throws {
        let node = try await SelfEvolvingFractalGossipNode(peer_id: "test")
        let model = SelfModel()
        model.updateSelf(from: node)
        XCTAssertGreaterThan(model.getRecursiveDepth(), 0)
    }
}
