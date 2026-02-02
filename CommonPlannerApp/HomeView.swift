//
//  HomeView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

struct HomeView: View {
    @State private var showSessionEntry = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                header

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {

                    FeatureTileView(
                        title: "Evlilik",
                        subtitle: "Eşyalar, masraflar ve kararlar tek yerde",
                        systemIcon: "heart.text.square",
                        isLocked: false
                    ) {
                        showSessionEntry = true
                    }

                    FeatureTileView(
                        title: "Ortak Yaşam",
                        subtitle: "Ev arkadaşı gelir-gider, görev ve liste",
                        systemIcon: "house.fill",
                        isLocked: true
                    ) {}

                    FeatureTileView(
                        title: "Etkinlik",
                        subtitle: "Arkadaş grubu planı, bütçe ve görevler",
                        systemIcon: "calendar.badge.plus",
                        isLocked: true
                    ) {}

                    FeatureTileView(
                        title: "Çok Yakında",
                        subtitle: "Yeni temalar ve premium özellikler",
                        systemIcon: "sparkles",
                        isLocked: true
                    ) {}
                }

                Spacer()
            }
            .padding(20)
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
            .sheet(isPresented: $showSessionEntry) {
                SessionEntrySheet()
                    .presentationDetents([.height(260)])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Common Planner")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("Ortak planla, hızlı karar ver.")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 10)
    }
}
