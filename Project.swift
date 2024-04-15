import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project

enum ProjectSettings {
	static var organizationName: String { "Mamlygo" }
	static var projectName: String { "CatanStats" }
	static var bundleId: String { "\(organizationName).\(projectName)" }
	static var destinations: Set<Destination> = Set<Destination>([Destination.iPhone])
	static var targetVersion: String { "15.0" }
}

private var swiftLintTargetScript: TargetScript {
	let swiftLintScriptString = """
		export PATH="$PATH:/opt/homebrew/bin"
		if which swiftlint > /dev/null; then
		 swiftlint
		else
		 echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
		 exit 1
		fi
		"""

	return TargetScript.pre(
		script: swiftLintScriptString,
		name: "Run Swiftlint",
		basedOnDependencyAnalysis: false
	)
}

let infoPlist: [String: Plist.Value] = [
	"CFBundleShortVersionString": "1.0",
	"CFBundleVersion": "1",
	"UILaunchStoryboardName": "LaunchScreen"
]

private var targets: [Target] {
	let mainTarget = Target(
		name: ProjectSettings.projectName,
		destinations: ProjectSettings.destinations,
		product: .app,
		bundleId: ProjectSettings.bundleId,
		deploymentTargets: DeploymentTargets(iOS: ProjectSettings.targetVersion),
		infoPlist: .extendingDefault(with: infoPlist),
		sources: ["Targets/\(ProjectSettings.projectName)/Sources/**"],
		resources: ["Targets/\(ProjectSettings.projectName)/Resources/**"],
		scripts: [swiftLintTargetScript],
		dependencies: [],
		coreDataModels: [
			CoreDataModel("Targets/\(ProjectSettings.projectName)/Sources/CoreData/CatanStats.xcdatamodeld")
		]
	)

	let testTarget = Target(
		name: "\(ProjectSettings.projectName)Tests",
		destinations: ProjectSettings.destinations,
		product: .unitTests,
		bundleId: "\(ProjectSettings.bundleId)Tests",
		deploymentTargets: DeploymentTargets(iOS: ProjectSettings.targetVersion),
		infoPlist: .default,
		sources: ["Targets/\(ProjectSettings.projectName)/Tests/**"],
		resources: ["Targets/\(ProjectSettings.projectName)/Resources/**"],
		dependencies: [
			.target(name: "\(ProjectSettings.projectName)")
		],
		coreDataModels: [
			CoreDataModel("Targets/\(ProjectSettings.projectName)/Sources/CoreData/CatanStats.xcdatamodeld")
		]
	)

	return [mainTarget, testTarget]
}

let app = Project(
	name: "CatanStats",
	targets: targets
)
