import Foundation

struct State: Codable {
    let cid: String
    let encrypted: String
    let peers: [String]
}

class CosmicGossipProtocol {
    func propagate_state(_ state: State, to peers: [String], churn: Double) async -> Bool {
        let replication_factor = 16 + Int(churn * 100 * 0.09)
        let successful_peers = peers.filter { _ in Double.random(in: 0...1) > churn }
        return successful_peers.count >= Int(Double(replication_factor) * 0.8)
    }
}
