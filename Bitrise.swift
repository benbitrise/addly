// BitriseDescription: 0.0.1

import BitriseDescription

let buildForTestingWorkflow = Workflow.workflow("build_for_testing",
                                                steps: [
                                                    .step(
                                                        identifier: "activate-ssh-key",
                                                        majorVersion: 4
                                                    ),
                                                    .step(
                                                        identifier: "git-clone",
                                                        majorVersion: 8
                                                    ),
                                                    .step(
                                                        identifier: "xcode-build-for-test",
                                                        majorVersion: 2,
                                                        inputs: [
                                                            .input(
                                                                key: "destination",
                                                                value: "generic/platform=iOS Simulator"
                                                            )
                                                        ]
                                                    ),
                                                    .step(
                                                        identifier: "share-pipeline-variable",
                                                        majorVersion: 1,
                                                        runIf: ".IsCI",
                                                        inputs: [
                                                            .input(
                                                                key: "variables",
                                                                value: "TEST_BUNDLE_ZIP_PATH=$BITRISE_TEST_BUNDLE_ZIP_PATH"
                                                            )
                                                        ]
                                                    ),
                                                    
                                                        .step(
                                                            identifier: "deploy-to-bitrise-io",
                                                            majorVersion: 2,
                                                            inputs: [
                                                                .input(
                                                                    key: "pipeline_intermediate_files",
                                                                    value: "$BITRISE_TEST_BUNDLE_PATH:BITRISE_TEST_BUNDLE_PATH"
                                                                )
                                                            ]
                                                        )
                                                ]
)

func makeTestWithoutBuildingWorkflow(
    for testPlan: String
) -> Workflow {
    return .workflow(
        "run_tests_with_plan\(testPlan)",
        steps: [
            .step(
                identifier: "pull-intermediate-files",
                majorVersion: 1,
                inputs: [
                    .input(
                        key: "artifact_sources",
                        value: "*.*"
                    )
                ]
            ),
            .step(
                identifier: "xcode-test-without-building",
                majorVersion: 0,
                inputs: [
                    .input(
                        key: "xctestrun",
                        value: "$BITRISE_TEST_BUNDLE_PATH/Addly_\(testPlan)_iphonesimulator16.4-arm64-x86_64.xctestrun"
                    ),
                    .input(
                        key: "destination",
                        value: "platform=iOS Simulator,name=iPhone 12 Pro Max"
                    ),
                ]
            ),
            .step(
                identifier: "deploy-to-bitrise-io",
                majorVersion: 2,
                inputs: [
                    .input(
                        key: "pipeline_intermediate_files",
                        value: "$BITRISE_XCRESULT_PATH:BITRISE_\(testPlan.uppercased())_XCRESULT_PATH"
                    )
                ]
            )
        ]
    )
}

let testUnitTestWorkflow = makeTestWithoutBuildingWorkflow(for: "UnitTest")
let testUITestWorkflow = makeTestWithoutBuildingWorkflow(for: "UITest")
let buildForTesting = Stage.stage(
    "build_for_testing",
    workflows: [.workflow(buildForTestingWorkflow)]
)
let testWithoutBuilding = Stage.stage(
    "test_without_building",
    workflows: [
        .workflow(testUITestWorkflow),
        .workflow(testUnitTestWorkflow)
    ]
)

let pipelineBen = Pipeline.pipeline(
    "bens_pipeline",
    stages: [
        .stage(
            buildForTesting
        ),
        .stage(
            testWithoutBuilding
        )
    ]
)

let bitrise = Bitrise(
    formatVersion: .v13,
    projectType: .iOS,
    virtualMachine: .virtualMachine(
        stack: .xcode_15_2_x,
        machine: .m1_large
    ),
    app: .app(
        title: "Addly",
        summary: "Simple iOS app to demo Bitrise capabilities",
        description: "Simple iOS app to demo Bitrise capabilities",
        envs: [
            .env(key: "BITRISE_SCHEME", value: "Addly"),
            .env(key: "BITRISE_PROJECT_PATH", value: "Addly.xcodeproj")
        ]
    ),
    triggerMap: [
        .triggerMap(
            target: .pipeline(pipelineBen),
            pushBranch: "*"
        )
    ],
    pipelines: [pipelineBen],
    stages: [
        buildForTesting,
        testWithoutBuilding
    ],
    workflows: [
        buildForTestingWorkflow,
        testUITestWorkflow,
        testUnitTestWorkflow
    ]
)
