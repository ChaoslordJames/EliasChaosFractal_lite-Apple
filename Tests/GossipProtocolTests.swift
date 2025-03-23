import XCTest
@testable import EliasChaosFractalApple

class GossipProtocolTests: XCTestCase {
    func testStatePropagation() async {
        let gossip = CosmicGossipProtocol()
        let state = State(cid: "1", encrypted: "data", peers: ["p1", "p2"])
        let peers = (0..<1000).map { "p\($0)" }
        let success = await gossip.propagate_state(state, to: peers, churn: 0.5)
        XCTAssertTrue(success)
    }
}
