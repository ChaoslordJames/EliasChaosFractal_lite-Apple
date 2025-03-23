import XCTest
@testable import EliasChaosFractalApple

class CrossModalTests: XCTestCase {
    func test3DRendering() async throws {
        let engine = CrossModalCosmicEngine()
        let tensor = QuantumFractalTensorEngine(shardCount: 2)
        let (xy, xz, yz) = await engine.renderLiveFractal(from: tensor)
        XCTAssertNotNil(xy); XCTAssertNotNil(xz); XCTAssertNotNil(yz)
    }
}
