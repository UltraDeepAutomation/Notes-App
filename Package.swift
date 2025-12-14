// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "NotesApp",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "NotesApp", targets: ["NotesApp"])
    ],
    targets: [
        .executableTarget(
            name: "NotesApp",
            path: "Sources"
        )
    ]
)
