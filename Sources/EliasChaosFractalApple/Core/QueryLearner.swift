import Foundation

class QueryLearner {
    private var queryPatterns: [String: Int] = [:]
    private var queryAssociations: [String: String] = [:]
    private var keywordAssociations: [String: String] = [:]
    private var phraseResponses: [String: String] = [:]

    func learnFromQuery(_ query: String, responseType: String) {
        let key = query.lowercased()
        queryPatterns[key, default: 0] += 1
        if queryPatterns[key]! > 5 {
            queryAssociations[key] = responseType
        }
    }

    func learnFromDocument(keywords: [String: Int], phrases: [String: Int]) {
        for (keyword, count) in keywords {
            if count > 2 {
                if keyword.contains("entropy") {
                    keywordAssociations[keyword] = "entropy"
                } else if keyword.contains("swarm") || keyword.contains("nodes") {
                    keywordAssociations[keyword] = "swarm_status"
                } else if keyword.contains("peers") {
                    keywordAssociations[keyword] = "peers_nodes"
                }
            }
        }

        for (phrase, count) in phrases {
            if count > 1 {
                if phrase.contains("entropy") && phrase.contains("stability") {
                    phraseResponses["entropy"] = "indicating stability"
                } else if phrase.contains("swarm") && phrase.contains("healthy") {
                    phraseResponses["swarm_status"] = "and it’s running healthy"
                }
            }
        }
    }

    func getPreferredResponseType(_ query: String) -> String? {
        let key = query.lowercased()
        if let responseType = queryAssociations[key] {
            return responseType
        }
        for (keyword, responseType) in keywordAssociations {
            if key.contains(keyword) {
                return responseType
            }
        }
        return nil
    }

    func enhanceResponse(_ responseType: String, baseResponse: String) -> String {
        if let enhancement = phraseResponses[responseType] {
            return "\(baseResponse), \(enhancement)."
        }
        return baseResponse
    }
}
