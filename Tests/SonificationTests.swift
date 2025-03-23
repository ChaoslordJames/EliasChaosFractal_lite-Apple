import XCTest
@testable import EliasChaosFractalApple

class SonificationTests: XCTestCase {
    func testSonify() {
        let sonification = FractalSonification()
        sonification.sonify(0.5)
    }
}
