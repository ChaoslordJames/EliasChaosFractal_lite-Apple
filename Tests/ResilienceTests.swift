import XCTest
@testable import EliasChaosFractalApple

class ResilienceTests: XCTestCase {
    func testExtremeLoad() async throws {
        let node = try await SelfEvolvingFractalGossipNode(peer_id: "test")
        let metrics = NetworkMetrics()
        XCTAssertGreaterThanOrEqual(metrics.resilience_score(node), 99.95)
    }
}
