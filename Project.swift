import ProjectDescription

// Tuist 4.13+ manifest using destinations/deploymentTargets and `.target` factory
let project = Project(
    name: "FTCoreTextDemo",
    organizationName: "FTCoreText",
    targets: [
        .target(
            name: "FTCoreText",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.example.ftcoretext",
            deploymentTargets: .iOS("14.0"),
            infoPlist: .default,
            sources: ["Sources/FTCoreText/**"]
        ),
        .target(
            name: "FTCoreTextDemo",
            destinations: .iOS,
            product: .app,
            bundleId: "com.example.ftcoretext.demo",
            deploymentTargets: .iOS("14.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchStoryboardName": .string("LaunchScreen")
            ]),
            sources: ["DemoApp/Sources/**"],
            resources: ["DemoApp/Resources/**"],
            dependencies: [
                .target(name: "FTCoreText")
            ],
            settings: .settings(base: [
                "ASSETCATALOG_COMPILER_APPICON_NAME": ""
            ])
        )
    ]
)
