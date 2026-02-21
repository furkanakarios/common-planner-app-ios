//
//  EditWeddingEntrySheet.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 9.02.2026.
//

import SwiftUI
import PhotosUI

struct EditWeddingEntrySheet: View {
    let entry: WeddingEntry

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: WeddingSessionStore

    @State private var title: String
    @State private var selectedCategoryId: UUID?
    @State private var priceText: String
    @State private var note: String
    @State private var link: String
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImagesData: [Data] = []

    @State private var showValidation = false

    init(entry: WeddingEntry) {
        self.entry = entry
        _title = State(initialValue: entry.title)
        _selectedCategoryId = State(initialValue: entry.categoryId)
        _priceText = State(initialValue: "\(entry.price)")
        _note = State(initialValue: entry.note ?? "")
        _link = State(initialValue: entry.link ?? "")
        _selectedImagesData = State(initialValue: entry.photos)
    }

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
                
                Section("Fotoğraflar (en fazla 5)") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Array(selectedImagesData.enumerated()), id: \.offset) { index, data in
                                if let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 72, height: 72)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        .overlay(alignment: .topTrailing) {
                                            Button {
                                                selectedImagesData.remove(at: index)
                                                if selectedItems.indices.contains(index) { selectedItems.remove(at: index) }
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .symbolRenderingMode(.palette)
                                                    .foregroundStyle(.white, .black.opacity(0.6))
                                                    .background(Circle().fill(Color.black.opacity(0.001)))
                                            }
                                            .offset(x: 4, y: -4)
                                        }
                                }
                            }

                            if selectedImagesData.count < 5 {
                                PhotosPicker(selection: $selectedItems, maxSelectionCount: 5 - selectedImagesData.count, matching: .images) {
                                    VStack(spacing: 6) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 18, weight: .semibold))
                                        Text("Ekle")
                                            .font(.footnote.weight(.semibold))
                                    }
                                    .frame(width: 72, height: 72)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color(.tertiarySystemFill))
                                    )
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                if showValidation && !isValid {
                    Section {
                        Text("Lütfen Başlık, Kategori ve geçerli bir Fiyat gir.")
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("Seçenek Düzenle")
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

                        let updated = WeddingEntry(
                            id: entry.id,
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            categoryId: categoryId,
                            price: price,
                            note: note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : note,
                            link: link.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : link,
                            photos: selectedImagesData,
                            status: entry.status,
                            createdAt: entry.createdAt
                        )

                        store.updateEntry(updated)
                        dismiss()
                    }
                }
            }
            .onChange(of: selectedItems) { oldValue, newValue in
                Task {
                    for item in newValue.suffix(5 - selectedImagesData.count) {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            if selectedImagesData.count < 5 { selectedImagesData.append(data) }
                        }
                    }
                }
            }
        }
    }

    private func parsePrice() -> Decimal? {
        let trimmed = priceText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        return Decimal(string: trimmed)
    }
}
