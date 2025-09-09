import ProjectDescription

let project = Project(
    name: "FTCoreTextDemo",
    organizationName: "FTCoreText",
    targets: [
        Target(
            name: "FTCoreText",
            platform: .iOS,
            product: .framework,
            bundleId: "com.example.ftcoretext",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["Sources/FTCoreText/**"],
            resources: [],
            dependencies: []
        ),
        Target(
            name: "FTCoreTextDemo",
            platform: .iOS,
            product: .app,
            bundleId: "com.example.ftcoretext.demo",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["DemoApp/Sources/**"],
            resources: [],
            dependencies: [
                .target(name: "FTCoreText")
            ]
        )
    ]
)
