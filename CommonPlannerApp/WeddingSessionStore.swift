//
//  WeddingSessionStore.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class WeddingSessionStore: ObservableObject {
    @Published var sessionCode: String
    @Published var categories: [WeddingCategory]
    @Published var entries: [WeddingEntry] = []

    init(sessionCode: String) {
        self.sessionCode = sessionCode

        let defaults: [WeddingCategory] = [
            .init(name: "Söz"),
            .init(name: "Nişan"),
            .init(name: "Düğün"),
            .init(name: "Ev Eşyası"),
            .init(name: "Balayı")
        ]
        self.categories = defaults
    }

    func categoryName(for id: UUID) -> String {
        categories.first(where: { $0.id == id })?.name ?? "Kategori"
    }

    func addCategory(name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        categories.append(.init(name: trimmed))
    }

    func deleteCategories(at offsets: IndexSet) {
        let idsToDelete = offsets.map { categories[$0].id }
        categories.remove(atOffsets: offsets)

        // Silinen kategoriye bağlı seçenekleri "kategori yok" durumuna sokmamak için:
        // En az 1 kategori varsa ilk kategoriye taşırız; yoksa entry’leri olduğu gibi bırakırız.
        guard let fallback = categories.first?.id else { return }
        for i in entries.indices {
            if idsToDelete.contains(entries[i].categoryId) {
                entries[i].categoryId = fallback
            }
        }
    }

    func moveCategories(from source: IndexSet, to destination: Int) {
        categories.move(fromOffsets: source, toOffset: destination)
    }

    func addEntry(_ entry: WeddingEntry) {
        entries.insert(entry, at: 0)
    }

    func updateStatus(entryId: UUID, status: WeddingEntryStatus) {
        guard let idx = entries.firstIndex(where: { $0.id == entryId }) else { return }
        entries[idx].status = status
    }

    func totalSelectedAmount() -> Decimal {
        entries
            .filter { $0.status == .selected }
            .reduce(0) { $0 + $1.price }
    }
    
    
    func updateEntry(_ updated: WeddingEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == updated.id }) else { return }
        entries[idx] = updated
    }
    
    
}
