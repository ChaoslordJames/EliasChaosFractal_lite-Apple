import XCTest
@testable import EliasChaosFractalApple

class NodeTests: XCTestCase {
    func testNodeInitialization() async throws {
        let node = try await SelfEvolvingFractalGossipNode(peer_id: "test")
        XCTAssertNotNil(node)
    }

    func testQueryProcessing() async throws {
        let node = try await SelfEvolvingFractalGossipNode(peer_id: "test")
        let response = await node.process_query("Hello")
        XCTAssert(response.contains("v4.7.4"))
    }
}
