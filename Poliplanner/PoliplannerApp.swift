//
//  PoliplannerApp.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 11/25/20.
//

import SwiftUI

@main
struct PoliplannerApp: App {
    @StateObject var poliplannerStore: PoliplannerStore = PoliplannerStore(realm: RealmProvider.realm())

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(poliplannerStore)
        }
    }
}
