// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "StudyPlanner",
    products: [
        .library(name: "StudyPlanner", targets: ["StudyPlanner"])
    ],
    targets: [
        .target(name: "StudyPlanner"),
        .testTarget(
            name: "StudyPlannerTests",
            dependencies: ["StudyPlanner"],
            resources: [.copy("Fixtures")]
        )
    ]
)
