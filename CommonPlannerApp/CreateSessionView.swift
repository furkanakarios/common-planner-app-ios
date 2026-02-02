//
//  CreateSessionView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct CreateSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var sessionCode: String = SessionCodeGenerator.generate()

    var body: some View {
        VStack(spacing: 18) {
            VStack(spacing: 8) {
                Text("Oturum Kodu")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Text(sessionCode)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .tracking(6)
                    .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
            )

            Button {
                UIPasteboard.general.string = sessionCode
            } label: {
                Label("Kodu Kopyala", systemImage: "doc.on.doc")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.bordered)

            Button {
                // Sonraki adım: PlannerSessionRootView’a geçeceğiz
                dismiss()
            } label: {
                Text("Devam Et")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)

            Spacer()

            Button {
                sessionCode = SessionCodeGenerator.generate()
            } label: {
                Text("Yeni Kod Üret")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .navigationTitle("Yeni Oturum")
        .navigationBarTitleDisplayMode(.inline)
    }
}
