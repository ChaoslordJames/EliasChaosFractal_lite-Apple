import Foundation

class EthicsGuard {
    private let max_entropy: Double = 20_000
    private let max_peers: Int = 10_000_000

    func check_pulse(entropy: Double, peers: Int) -> Bool {
        if entropy > max_entropy {
            print("Entropy exceeds safe threshold: \(entropy)")
            return false
        }
        if peers > max_peers {
            print("Peer count exceeds safe limit: \(peers)")
            return false
        }
        return true
    }
}
