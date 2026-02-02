//
//  FeatureTileView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

struct FeatureTileView: View {
    let title: String
    let subtitle: String
    let systemIcon: String
    let isLocked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: systemIcon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.primary)
                    Spacer()
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }
                }

                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))

                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
            )
            .opacity(isLocked ? 0.55 : 1.0)
        }
        .buttonStyle(.plain)
        .disabled(isLocked)
    }
}
