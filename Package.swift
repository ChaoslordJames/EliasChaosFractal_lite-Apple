// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "EliasChaosFractalApple",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "EliasChaosFractalApple", targets: ["EliasChaosFractalApple"]),
        .executable(name: "NetworkSwarm", targets: ["NetworkSwarm"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EliasChaosFractalApple",
            dependencies: [],
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
                "Core/DocumentProcessor.swift",
                "Core/QueryLearner.swift",
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
            sources: ["NetworkSwarm.swift", "EliasGUI.swift"],
            resources: [
                .copy("Resources/swarm_basics.txt"),
                .copy("Resources/entropy_guide.txt"),
                .copy("Resources/peer_dynamics.txt"),
                .copy("Resources/communication_tips.txt"),
                .copy("Resources/swarm_metrics.txt")
            ]
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
                "ResilienceTests.swift",
                "TensorEngineTests.swift",
                "CrossModalTests.swift",
                "SonificationTests.swift"
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
