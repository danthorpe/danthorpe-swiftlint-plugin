// swift-tools-version: 5.7
import PackageDescription

var package = Package(name: "danthorpe-swiftlint-plugin")

// MARK: 💫 Package Customization

package.defaultLocalization = "en"
package.platforms = [
    .macOS(.v12),
    .iOS(.v14),
    .tvOS(.v14),
    .watchOS(.v7)
]

/// ✨ These are all special case targets, such as plugins
/// ------------------------------------------------------------

// MARK: - 🧮 Binary Targets & Plugins

extension Target {
    static let swiftLintBinary: Target = .binaryTarget(
        name: "SwiftLintBinary",
        url: "https://github.com/realm/SwiftLint/releases/download/0.52.0/SwiftLintBinary-macos.artifactbundle.zip",
        checksum: "7b956238d2937084a66b89cb68cfcde673f85d1202b37edea9c3f193dec8a2d9"
    )
    static let swiftLintPlugin: Target = .plugin(
        name: "SwiftLintPlugin",
        capability: .buildTool(),
        dependencies: [
            "SwiftLintBinary"
        ])
    static let swiftLintAutocorrectPlugin: Target = .plugin(
        name: "SwiftLintAutocorrectPlugin",
        capability: .command(
            intent: .custom(
                verb: "swiftlint",
                description: "Invokes swiftlint --autocorrect, which will fix all correctable violations."
            ),
            permissions: [
                .writeToPackageDirectory(reason: "All correctable violations are fixed by SwiftLint.")
            ]
        ),
        dependencies: [
            "SwiftLintBinary"
        ])
}

var plugins: [Target] = [
    .swiftLintBinary,
    .swiftLintPlugin,
    .swiftLintAutocorrectPlugin,
]

package.targets.append(contentsOf: plugins)

// MARK: Products

package.products = [
    .plugin(name: "SwiftLintPlugin", targets: ["SwiftLintPlugin"]),
]
