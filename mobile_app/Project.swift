import ProjectDescription

let project = Project(
    name: "Notes",
    settings: .settings(configurations: [
        .debug(name: "Debug", xcconfig: "./xcconfigs/Notes-Project.xcconfig"),
        .release(name: "Release", xcconfig: "./xcconfigs/Notes-Project.xcconfig"),
    ]),
    targets: [
        .target(
            name: "Notes",
            destinations: .iOS,
            product: .app,
            bundleId: "com.michaelslattery.Notes",
            deploymentTargets: .iOS("17.0"),
            sources: ["Notes/Sources/**"],
            resources: ["Notes/Resources/**"],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                /** Dependencies go here **/
                /** .external(name: "Kingfisher") **/
                /** .target(name: "OtherProjectTarget") **/
            ],
            settings: .settings(configurations: [
                .debug(name: "Debug", xcconfig: "./xcconfigs/Notes.xcconfig"),
                .debug(name: "Release", xcconfig: "./xcconfigs/Notes.xcconfig"),
            ])
        ),
        .target(
            name: "NotesTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.michaelslattery.NotesTests",
            infoPlist: .default,
            sources: ["NotesTests/**"],
            resources: [],
            dependencies: [
                .target(name: "Notes")
            ]
        ),
        .target(
            name: "NotesUITests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.michaelslattery.NotesUITests",
            infoPlist: .default,
            sources: ["NotesUITests/**"],
            resources: [],
            dependencies: [
                .target(name: "Notes")
            ]
        ),
    ]
)
