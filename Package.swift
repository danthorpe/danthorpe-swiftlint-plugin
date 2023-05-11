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
        url: "https://github.com/realm/SwiftLint/releases/download/0.50.3/SwiftLintBinary-macos.artifactbundle.zip",
        checksum: "abe7c0bb505d26c232b565c3b1b4a01a8d1a38d86846e788c4d02f0b1042a904"
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
