import Foundation

class PeerDiscovery {
    static func get_peers(_ node: SelfEvolvingFractalGossipNode) async -> [String] {
        return (0..<1000).map { "mock_peer_\($0)" }
    }

    static func update_peers(_ new_peers: [String]) {}
}
