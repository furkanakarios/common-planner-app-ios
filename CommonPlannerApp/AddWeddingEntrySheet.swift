//
//  AddWeddingEntrySheet.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

struct AddWeddingEntrySheet: View {
    
    let preselectedCategoryId: UUID?

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: WeddingSessionStore
    
    @State private var title: String = ""
    @State private var selectedCategoryId: UUID?
    @State private var priceText: String = ""
    @State private var note: String = ""
    @State private var link: String = ""

    @State private var showValidation = false

    var isValid: Bool {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        guard selectedCategoryId != nil else { return false }
        guard parsePrice() != nil else { return false }
        return true
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Zorunlu") {
                    TextField("Başlık", text: $title)

                    Picker("Kategori", selection: Binding(
                        get: { selectedCategoryId ?? store.categories.first?.id },
                        set: { selectedCategoryId = $0 }
                    )) {
                        ForEach(store.categories) { cat in
                            Text(cat.name).tag(cat.id as UUID?)
                        }
                    }

                    TextField("Fiyat (₺)", text: $priceText)
                        .keyboardType(.decimalPad)
                }

                Section("Opsiyonel") {
                    TextField("Not", text: $note, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)

                    TextField("Link", text: $link)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                if showValidation && !isValid {
                    Section {
                        Text("Lütfen Başlık, Kategori ve geçerli bir Fiyat gir.")
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("Seçenek Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kaydet") {
                        guard let categoryId = selectedCategoryId ?? store.categories.first?.id else { return }
                        guard let price = parsePrice() else {
                            showValidation = true
                            return
                        }
                        let entry = WeddingEntry(
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            categoryId: categoryId,
                            price: price,
                            note: note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : note,
                            link: link.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : link,
                            status: .candidate
                        )
                        store.addEntry(entry)
                        dismiss()
                    }
                }
            }
            .onAppear {
                if selectedCategoryId == nil {
                    // 1) Eğer ekrandan bir kategori seçili gelmişse onu kullan
                    if let pre = preselectedCategoryId,
                       store.categories.contains(where: { $0.id == pre }) {
                        selectedCategoryId = pre
                    } else {
                        // 2) Yoksa ilk kategoriye düş
                        selectedCategoryId = store.categories.first?.id
                    }
                }
            }
        }
    }

    private func parsePrice() -> Decimal? {
        let trimmed = priceText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        // TR: virgül destek
        let normalized = trimmed.replacingOccurrences(of: ",", with: ".")
        return Decimal(string: normalized)
    }
}
