//
//  WeddingEntryCard.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//
//
//  WeddingEntryCard.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

struct WeddingEntryCard: View {
    @State private var showEdit = false
    @EnvironmentObject private var store: WeddingSessionStore
    let entry: WeddingEntry
    @State private var showImageViewer = false
    @State private var previewImages: [UIImage] = []
    @State private var selectedPreviewIndex: Int = 0

    var statusText: String {
        switch entry.status {
        case .candidate: return "Aday"
        case .selected: return "Seçildi"
        case .eliminated: return "Elendi"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            // Üst satır: Kategori (sol) + Durum Menüsü (sağ) + Edit ikonu (durumun altında)
            HStack(alignment: .top) {
                Text(store.categoryName(for: entry.categoryId))
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    Menu {
                        Button {
                            store.updateStatus(entryId: entry.id, status: .candidate)
                        } label: {
                            Label("Aday", systemImage: "circle")
                        }

                        Button {
                            store.updateStatus(entryId: entry.id, status: .selected)
                        } label: {
                            Label("Seçilen", systemImage: "checkmark.circle.fill")
                        }

                        Button {
                            store.updateStatus(entryId: entry.id, status: .eliminated)
                        } label: {
                            Label("Elenen", systemImage: "xmark.circle.fill")
                        }
                    } label: {
                        Text(statusText)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule().fill(statusPillColor)
                            )
                    }

                }
            }

            // Başlık satırı (artık solda edit ikonu yok)
            HStack(alignment: .center, spacing: 8) {
                Text(entry.title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))

                Spacer(minLength: 0)

                Button {
                    showEdit = true
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            Text("\(formatCurrency(entry.price)) (\(entry.paymentOption.rawValue))")
                .font(.system(size: 16, weight: .bold, design: .rounded))

            if !entry.photos.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(entry.photos.enumerated()), id: \.offset) { idx, data in
                            if let uiImage = UIImage(data: data) {
                                Button {
                                    selectedPreviewIndex = idx
                                    previewImages = entry.photos.compactMap { UIImage(data: $0) }
                                    showImageViewer = true
                                } label: {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 56, height: 56)
                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.top, 6)
                }
            }

            if let note = entry.note, !note.isEmpty {
                Text(note)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                store.updateStatus(entryId: entry.id, status: .selected)
            } label: {
                Label("Seç", systemImage: "checkmark.circle.fill")
            }
            .tint(.green)

            Button {
                store.updateStatus(entryId: entry.id, status: .eliminated)
            } label: {
                Label("Ele", systemImage: "xmark.circle.fill")
            }
            .tint(.red)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                store.updateStatus(entryId: entry.id, status: .candidate)
            } label: {
                Label("Geri Al", systemImage: "arrow.uturn.left.circle")
            }
            .tint(.gray)
        }
        .sheet(isPresented: $showEdit) {
            EditWeddingEntrySheet(entry: entry)
                .environmentObject(store)
        }
        .fullScreenCover(isPresented: $showImageViewer) {
            ImageViewer(images: previewImages, startIndex: selectedPreviewIndex)
        }
    }

    private func formatCurrency(_ value: Decimal) -> String {
        let number = NSDecimalNumber(decimal: value)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: number) ?? "\(number)"
    }

    private var statusPillColor: Color {
        switch entry.status {
        case .candidate: return Color(.tertiarySystemFill)
        case .selected: return Color.green.opacity(0.18)
        case .eliminated: return Color.red.opacity(0.16)
        }
    }
}
private struct ImageViewer: View {
    let images: [UIImage]
    @State var index: Int
    @Environment(\.dismiss) private var dismiss

    init(images: [UIImage], startIndex: Int) {
        self.images = images
        self._index = State(initialValue: startIndex)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if !images.isEmpty {
                TabView(selection: $index) {
                    ForEach(Array(images.enumerated()), id: \.offset) { i, img in
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .tag(i)
                            .ignoresSafeArea()
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
            }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(12)
                    }
                }
                Spacer()
            }
        }
    }
}

