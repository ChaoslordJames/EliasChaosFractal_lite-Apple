import XCTest
@testable import EliasChaosFractalApple

class ResilienceTests: XCTestCase {
    func testExtremeLoad() async throws {
        let node = try await SelfEvolvingFractalGossipNode(peer_id: "test")
        let metrics = NetworkMetrics()
        node.active_nodes.store(1000, ordering: .relaxed)
        XCTAssertGreaterThanOrEqual(metrics.resilience_score(node), 99.95)
    }
}
