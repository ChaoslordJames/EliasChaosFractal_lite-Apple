import Foundation

class EliasNLPInterface {
    private let node: SelfEvolvingFractalGossipNode
    private var contextual_memory = RingBuffer<DialogueFrame>(capacity: 800)
    private let queryLearner = QueryLearner()
    private let documentProcessor = DocumentProcessor()

    init(node: SelfEvolvingFractalGossipNode) { self.node = node }

    func processDocument(_ url: URL) {
        guard documentProcessor.processDocument(url: url),
              let text = documentProcessor.extractText(from: url) else { return }
        let keywords = documentProcessor.extractKeywords(from: text)
        let phrases = documentProcessor.extractPhrases(from: text)
        queryLearner.learnFromDocument(keywords: keywords, phrases: phrases)
    }

    func process_query(_ query: String, depth: Int, withSelfModel selfModel: SelfModel) async -> String {
        contextual_memory.append(DialogueFrame(content: query, timestamp: Date(), depth: depth))
        selfModel.updateSelf(from: node)

        let lowerQuery = query.lowercased()
        let entropy = selfModel.self_state["entropy"] ?? 0
        let cosmic = selfModel.quantum_state["cosmicEntropy"] ?? 0
        let peers = node.active_nodes.load(ordering: .relaxed)

        var responseType: String
        if let learnedType = queryLearner.getPreferredResponseType(query) {
            responseType = learnedType
        } else if lowerQuery.contains("how") && lowerQuery.contains("swarm") {
            responseType = "swarm_status"
        } else if lowerQuery.contains("entropy") {
            responseType = "entropy"
        } else if lowerQuery.contains("peers") || lowerQuery.contains("nodes") {
            responseType = "peers_nodes"
        } else if lowerQuery.contains("help") || lowerQuery.contains("what can") {
            responseType = "help"
        } else {
            responseType = "unknown"
        }

        var response: String
        switch responseType {
        case "swarm_status":
            response = "The swarm’s doing great! It has 20 nodes and \(peers) peers, with an entropy of \(entropy)."
            queryLearner.learnFromQuery(query, responseType: "swarm_status")
        case "entropy":
            response = "The swarm’s entropy is currently \(entropy), and cosmic entropy is \(cosmic). It’s managing \(peers) peers."
            queryLearner.learnFromQuery(query, responseType: "entropy")
        case "peers_nodes":
            response = "Right now, the swarm has 20 nodes and \(peers) active peers."
            queryLearner.learnFromQuery(query, responseType: "peers_nodes")
        case "help":
            response = "I can tell you about the swarm! Try asking about its entropy, peers, or how it’s doing."
            queryLearner.learnFromQuery(query, responseType: "help")
        default:
            response = "I’m still learning to understand questions like that. Could you ask about the swarm’s entropy or peers?"
            queryLearner.learnFromQuery(query, responseType: "unknown")
        }

        response = queryLearner.enhanceResponse(responseType, baseResponse: response)

        if let lastFrame = contextual_memory.getLatest(), lastFrame.content != query {
            let lastEntropy = try? JSONDecoder().decode([String: Double].self, from: Data(lastFrame.content.utf8))["entropy"]
            if let lastEntropy = lastEntropy, lowerQuery.contains("entropy") {
                let delta = entropy - lastEntropy
                response += " Since your last query, entropy has \(delta >= 0 ? "increased" : "decreased") by \(abs(delta))."
            }
        }

        return await recursivelyRefine(response, forQuery: query, attempts: min(depth + 1, 15))
    }

    private func recursivelyRefine(_ response: String, forQuery query: String, attempts: Int) async -> String {
        if attempts <= 0 { return response }
        let coherence = Double.random(in: 0...1)
        if coherence > 0.9 { return response }
        return await recursivelyRefine("\(response) refined", forQuery: query, attempts: attempts - 1)
    }
}
