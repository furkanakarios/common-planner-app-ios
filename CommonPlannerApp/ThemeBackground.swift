//
//  ThemeBackground.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 9.02.2026.
//

import SwiftUI

struct ThemeBackground: View {
    var body: some View {
        LinearGradient(
          colors: [Color.red.opacity(0.25), Color.blue.opacity(0.25)],
          startPoint: .top,
          endPoint: .bottom
        )
        .ignoresSafeArea()

    }
}
