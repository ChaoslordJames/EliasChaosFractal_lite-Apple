import Foundation

class AdaptiveTopology {
    private var kBuckets: [KBucket] = []

    func optimizeForPeers(_ count: Int) -> [KBucket] {
        let bucket_count = max(count / 2000, 2500)
        kBuckets = (0..<bucket_count).map { KBucket(distance: $0, k: 20) }
        return kBuckets
    }
}

struct KBucket {
    let distance: Int
    let k: Int
    var peers: [String] = []
}
