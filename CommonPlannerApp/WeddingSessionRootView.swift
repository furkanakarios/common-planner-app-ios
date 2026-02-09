//
//  WeddingSessionRootView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

struct WeddingSessionRootView: View {
    @StateObject private var store: WeddingSessionStore

    init(sessionCode: String) {
        _store = StateObject(wrappedValue: WeddingSessionStore(sessionCode: sessionCode))
    }

    var body: some View {
        ZStack {
            ThemeBackground()

            TabView {
                WeddingOptionsView()
                    .tabItem { Label("Seçenekler", systemImage: "square.grid.2x2") }

                WeddingExpensesView()
                    .tabItem { Label("Harcamalar", systemImage: "creditcard") }

                WeddingSummaryView()
                    .tabItem { Label("Özet", systemImage: "chart.bar") }
            }
            .environmentObject(store)
        }
        .background(Color.clear)
        .toolbarBackground(.hidden, for: .tabBar)
    }
}
