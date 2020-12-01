//
//  ContentView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 11/25/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var poliplannerStore: PoliplannerStore

    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PoliplannerStore(realm: RealmProvider.realm()))
    }
}
