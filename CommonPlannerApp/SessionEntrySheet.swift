//
//  SessionEntrySheet.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

struct SessionEntrySheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                Capsule()
                    .fill(Color.secondary.opacity(0.35))
                    .frame(width: 44, height: 5)
                    .padding(.top, 8)

                Text("Evlilik Oturumu")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))

                Text("Yeni bir ortak oturum başlatabilir veya kod ile mevcut oturuma katılabilirsin.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)

                Spacer().frame(height: 6)

                NavigationLink {
                    CreateSessionView()
                } label: {
                    Text("Yeni Oturum Başlat")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)

                NavigationLink {
                    JoinSessionView()
                } label: {
                    Text("Oturuma Katıl")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding(18)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kapat") { dismiss() }
                }
            }
        }
    }
}
