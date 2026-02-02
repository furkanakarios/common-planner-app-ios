//
//  SessionEntrySheet.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

struct SessionEntrySheet: View {
    let onCreate: () -> Void
    let onJoin: () -> Void

    var body: some View {
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

            Button(action: onCreate) {
                Text("Yeni Oturum Başlat")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)

            Button(action: onJoin) {
                Text("Oturuma Katıl")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .padding(18)
    }
}
