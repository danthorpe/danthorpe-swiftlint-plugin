import Foundation
import PackagePlugin

@main
struct SwiftLint: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let target = target as? SwiftSourceModuleTarget else {
            return []
        }
        guard let helper = try Helper(context: context, target: target) else {
            Diagnostics.error("Unable to find swiftlint tool")
            return []
        }
        return [
            .prebuildCommand(
                displayName: "Linting \(target.name)",
                executable: helper.tool,
                arguments: helper.arguments,
                outputFilesDirectory: helper.outputFiles
            )
        ]
    }
}

extension SwiftLint {
    struct Helper {
        var tool: Path
        var cache: Path
        var config: Path
        var inputFiles: [Path]
        var outputFiles: Path

        var arguments: [String] {
            ["lint",
             "--quiet",
             "--cache-path", cache.string,
             "--config", config.string
            ] + inputFiles.map(\.string)
        }

        init(
            tool: Path,
            cache: Path,
            config: Path,
            inputFiles: [Path],
            outputFiles: Path
        ) {
            self.tool = tool
            self.cache = cache
            self.config = config
            self.inputFiles = inputFiles
            self.outputFiles = outputFiles
        }

        init?(context: PluginContext, target: SwiftSourceModuleTarget) throws {
            self.init(
                tool: try context.tool(named: "swiftlint").path,
                cache: context.pluginWorkDirectory.appending("Cache"),
                config: context.package.directory.appending(".swiftlint.yml"),
                inputFiles: target.sourceFiles(withSuffix: "swift").map(\.path),
                outputFiles: context.pluginWorkDirectory.appending("Output")
            )
        }
    }
}
