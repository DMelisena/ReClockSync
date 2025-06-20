import ProjectDescription

let project = Project(
    name: "ReClockSync",
    targets: [
        .target(
            name: "ReClockSync",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.ReClockSync",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: [
                .external(name: "Inject"),
            ],

            // MARK: - Add Other Linker Flags and User Defined Build Settings here

            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": [
                        "$(inherited)", // Always include this to preserve default linker flags
                        "-Xlinker", // Passes the next argument directly to the linker
                        "-interposable", // The actual linker flag
                        // You can add more flags here, each as a separate string element
                        // "-Xlinker", "-some_other_linker_flag",
                        // "-framework", "MyCustomFramework" // Example for linking a framework
                    ],
                    // User defined build setting
                    "EMIT_FRONTEND_COMMAND_LINES": "YES",
                ]
                // You can also add configurations specific settings if needed
                // configurations: [
                //     .debug(name: .debug, settings: [
                //         "OTHER_LDFLAGS": ["-Xlinker", "-interposable"],
                //         "EMIT_FRONTEND_COMMAND_LINES": "YES"
                //     ]),
                //     .release(name: .release, settings: [
                //         "OTHER_LDFLAGS": ["-Xlinker", "-interposable"],
                //         "EMIT_FRONTEND_COMMAND_LINES": "YES"
                //     ])
                // ]
            )
        ),
        .target(
            name: "ReClockSyncTest",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.ReClockSyncTest",
            infoPlist: .default,
            sources: ["App/Tests/**"],
            resources: [],
            dependencies: [.target(name: "ReClockSync")]
        ),
    ]
)
