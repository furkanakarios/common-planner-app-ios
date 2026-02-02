//
//  WeddingSummaryView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

struct WeddingSummaryView: View {
    @EnvironmentObject private var store: WeddingSessionStore

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                summaryCard
                Spacer()
                Text("PDF dışa aktarma ve detay raporlar bir sonraki adımda eklenecek.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 18)
                Spacer()
            }
            .padding(16)
            .navigationTitle("Özet")
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Genel Durum")
                .font(.system(size: 18, weight: .semibold, design: .rounded))

            HStack {
                metric("Aday", store.entries.filter { $0.status == .candidate }.count)
                metric("Seçilen", store.entries.filter { $0.status == .selected }.count)
                metric("Elenen", store.entries.filter { $0.status == .eliminated }.count)
            }

            Divider().opacity(0.6)

            HStack {
                Text("Seçilen Toplam")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(formatCurrency(store.totalSelectedAmount()))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }

    private func metric(_ title: String, _ value: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(value)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text(title)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func formatCurrency(_ value: Decimal) -> String {
        let number = NSDecimalNumber(decimal: value)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: number) ?? "\(number)"
    }
}
