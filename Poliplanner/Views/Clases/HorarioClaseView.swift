//
//  HorarioClaseView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-01.
//

import SwiftUI

struct HorarioClaseView: View {
    @EnvironmentObject var PPStore: PoliplannerStore
    @StateObject private var HCViewModel = HorarioClaseViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Placeholder")
            }
        }
    }
}

struct HorarioClaseView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PoliplannerStore(realm: RealmProvider.realm()))
    }
}
