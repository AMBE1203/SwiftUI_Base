//
//  SettingsView.swift
//  IosTakeHomeTest
//
//  Created by AMBE on 11/11/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage(UserDefaultKeys.hapticsEnabled) private var isHapticsEnabled: Bool = true
    
    var body: some View {
            Form {
                hapticsView
            }
            .navigationTitle("Settings")
            .embedInNavigation()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

private extension SettingsView {
    var hapticsView: some View {
        Toggle("Enable Haptics",isOn: $isHapticsEnabled)
    }
}
