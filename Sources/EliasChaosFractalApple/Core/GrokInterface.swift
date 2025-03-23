import Foundation

class GrokInterface {
    let websocket: URLSessionWebSocketTask
    init() {
        let url = URL(string: "ws://grok.xai:8080")! // Hypothetical
        let session = URLSession(configuration: .default)
        self.websocket = session.webSocketTask(with: url)
        websocket.resume()
    }
    func query_grok(_ hypothesis: String) async -> String? {
        let collab = Collaborate(hypothesis: hypothesis, source: "Elias")
        let json = try! JSONEncoder().encode(collab)
        websocket.send(.data(json)) { _ in }
        if let message = try? await websocket.receive(), case .data(let data) = message {
            let response = try? JSONDecoder().decode(Collaborate.self, from: data)
            return response?.hypothesis
        }
        return nil
    }
}
