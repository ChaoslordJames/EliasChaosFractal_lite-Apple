import XCTest
@testable import EliasChaosFractalApple

class EmotionalModelTests: XCTestCase {
    func testCosmicFeedback() {
        let model = EmotionalStateModel()
        let tensor = QuantumFractalTensorEngine(shardCount: 2)
        model.adjustWithCosmicFeedback(from: tensor)
        XCTAssertGreaterThan(model.emotional_dimensions["cosmicResonance"]!, 0)
    }
}
