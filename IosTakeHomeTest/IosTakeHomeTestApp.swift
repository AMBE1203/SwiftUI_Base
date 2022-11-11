//
//  IosTakeHomeTestApp.swift
//  IosTakeHomeTest
//
//  Created by AMBE on 09/11/2022.
//

import SwiftUI

@main
struct IosTakeHomeTestApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                PeopleView()
                    .tabItem {
                        Symbols.person
                        Text("Home")
                    }
                
                SettingsView()
                    .tabItem {
                        Symbols.gear
                        Text("Settings")
                    }
            }
            
        }
    }
}
