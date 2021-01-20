// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {
    
    func cocoapodLane() {
        desc("Instala las dependencias de cocoapod")
        cocoapods(cleanInstall: true)
    }
    
    func swiftLintLane() {
        desc("Correr SwiftLint")
        swiftlint(configFile: ".swiftlint.yml",
                  ignoreExitStatus: false,
                  raiseIfSwiftlintError: true,
                  executable: "Pods/SwiftLint/swiftlint")
    }
    
    func buildLane() {
        desc("Compilar para testear")
        scan(workspace: "Poliplanner.xcworkspace",
             derivedDataPath: "derivedData",
             buildForTesting: true,
             xcargs: "CI=true")
    }
    
    func unitTestLane() {
            desc("Correr test unitarios")
            scan(workspace: "Poliplanner.xcworkspace",
                 onlyTesting: ["PoliplannerTests"],
                 derivedDataPath: "derivedData",
                 testWithoutBuilding: true)
    }
}
