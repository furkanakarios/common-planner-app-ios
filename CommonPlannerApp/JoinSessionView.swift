//
//  JoinSessionView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

struct JoinSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var code: String = ""
    @State private var showError = false

    var body: some View {
        VStack(spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Oturum Kodunu Gir")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))

                Text("6 haneli kodu girerek mevcut oturuma katılabilirsin.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            TextField("Örn: 483920", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(showError ? Color.red.opacity(0.7) : Color.black.opacity(0.06), lineWidth: 1)
                )
                .onChange(of: code) { _, newValue in
                    // sadece rakam + max 6
                    let filtered = newValue.filter { $0.isNumber }
                    code = String(filtered.prefix(6))
                    showError = false
                }

            Button {
                guard code.count == 6 else {
                    showError = true
                    return
                }

                // Sonraki adım: “koda göre oturum bul / bağlan” eklenecek
                dismiss()
            } label: {
                Text("Katıl")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .disabled(code.count < 6)

            Spacer()
        }
        .padding(20)
        .navigationTitle("Oturuma Katıl")
        .navigationBarTitleDisplayMode(.inline)
    }
}
