// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "EliasChaosFractalApple",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "EliasChaosFractalApple", targets: ["EliasChaosFractalApple"]),
        .executable(name: "NetworkSwarm", targets: ["NetworkSwarm"])
    ],
    dependencies: [
        .package(url: "https://github.com/redis/redis-swift.git", from: "1.2.0") // Hypothetical
    ],
    targets: [
        .target(
            name: "EliasChaosFractalApple",
            dependencies: [.product(name: "Redis", package: "redis-swift")],
            path: "Sources/EliasChaosFractalApple",
            sources: [
                "Core/SelfEvolvingFractalGossipNode.swift",
                "Core/EmotionalStateModel.swift",
                "Core/SelfModel.swift",
                "Core/EliasNLPInterface.swift",
                "Core/DialogueFrame.swift",
                "Core/RingBuffer.swift",
                "Core/Collaborate.swift",
                "Core/EthicsGuard.swift",
                "Core/Resolver.swift",
                "Core/GrokInterface.swift",
                "Network/CosmicGossipProtocol.swift",
                "Network/PeerDiscovery.swift",
                "Network/NetworkMetrics.swift",
                "Quantum/QuantumFractalTensorEngine.swift",
                "Quantum/CosmicEntropy.swift",
                "Evolution/CosmicArchitecturalEvolution.swift",
                "Evolution/AdaptiveTopology.swift",
                "Rendering/CrossModalCosmicEngine.swift",
                "Rendering/FractalSonification.swift",
                "Rendering/FractalVisualization.swift",
                "Utils/ConsciousnessExperiment.swift",
                "Storage/StateManager.swift",
                "Storage/RedisInterface.swift"
            ]
        ),
        .executableTarget(
            name: "NetworkSwarm",
            dependencies: ["EliasChaosFractalApple"],
            path: "Sources/NetworkSwarm",
            sources: ["NetworkSwarm.swift", "EliasGUI.swift"]
        ),
        .testTarget(
            name: "EliasChaosFractalAppleTests",
            dependencies: ["EliasChaosFractalApple"],
            path: "Tests",
            sources: [
                "NodeTests.swift",
                "EmotionalModelTests.swift",
                "SelfModelTests.swift",
                "GossipProtocolTests.swift",
                "ResilienceTests.swift"
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
