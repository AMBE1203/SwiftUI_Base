//
//  View+Navigation.swift
//  IosTakeHomeTest
//
//  Created by AMBE on 11/11/2022.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func embedInNavigation() -> some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                self
            }
        } else {
            NavigationView {
                self
            }
        }
    }
}
