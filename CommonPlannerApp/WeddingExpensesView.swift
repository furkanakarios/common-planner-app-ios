//
//  WeddingExpensesView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

struct WeddingExpensesView: View {
    @EnvironmentObject private var store: WeddingSessionStore

    private var selected: [WeddingEntry] {
        store.entries.filter { $0.status == .selected }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ThemeBackground()

                VStack {
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
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
                .padding(20)
                .background(.ultraThinMaterial.opacity(0.85))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .navigationTitle("Harcamalar")
            .toolbarBackground(.hidden, for: .navigationBar)
            .background(Color.clear)
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
