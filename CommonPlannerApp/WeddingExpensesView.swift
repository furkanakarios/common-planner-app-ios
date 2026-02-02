//
//  WeddingExpensesView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

struct WeddingExpensesView: View {
    @EnvironmentObject private var store: WeddingSessionStore

    var selected: [WeddingEntry] {
        store.entries.filter { $0.status == .selected }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Toplam Seçilen")
                        Spacer()
                        Text(formatCurrency(store.totalSelectedAmount()))
                            .fontWeight(.semibold)
                    }
                }

                Section("Seçilenler") {
                    if selected.isEmpty {
                        Text("Henüz seçilen bir kayıt yok.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(selected) { e in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(e.title).font(.headline)
                                Text(store.categoryName(for: e.categoryId))
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                Text(formatCurrency(e.price))
                                    .font(.subheadline.weight(.semibold))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Harcamalar")
        }
    }

    private func formatCurrency(_ value: Decimal) -> String {
        let number = NSDecimalNumber(decimal: value)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: number) ?? "\(number)"
    }
}
