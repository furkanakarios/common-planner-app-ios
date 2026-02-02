//
//  WeddingOptionsView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

enum OptionsFilter: String, CaseIterable {
    case all = "Tümü"
    case candidate = "Aday"
    case selected = "Seçilen"
    case eliminated = "Elenen"
}

struct WeddingOptionsView: View {
    @EnvironmentObject private var store: WeddingSessionStore
    @State private var filter: OptionsFilter = .all
    @State private var showAddEntry = false
    @State private var showManageCategories = false
    @State private var selectedCategoryId: UUID? = nil

    var filteredEntries: [WeddingEntry] {
        let byStatus: [WeddingEntry] = {
            switch filter {
            case .all: return store.entries
            case .candidate: return store.entries.filter { $0.status == .candidate }
            case .selected: return store.entries.filter { $0.status == .selected }
            case .eliminated: return store.entries.filter { $0.status == .eliminated }
            }
        }()

        guard let selectedCategoryId else { return byStatus }
        return byStatus.filter { $0.categoryId == selectedCategoryId }
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                sessionHeader

                Picker("", selection: $filter) {
                    ForEach(OptionsFilter.allCases, id: \.self) { f in
                        Text(f.rawValue).tag(f)
                    }
                }
                .pickerStyle(.segmented)
                categoryFilterChips

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredEntries) { entry in
                            WeddingEntryCard(entry: entry)
                        }
                        if filteredEntries.isEmpty {
                            emptyState
                                .padding(.top, 30)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 16)
            .navigationBarHidden(true)
            .safeAreaInset(edge: .bottom) {
                Button {
                    showAddEntry = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                        Text("Seçenek Ekle")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
                .background(.ultraThinMaterial)
            }
            .sheet(isPresented: $showAddEntry) {
                AddWeddingEntrySheet(preselectedCategoryId: selectedCategoryId)
            }
            .sheet(isPresented: $showManageCategories) {
                ManageCategoriesView()
            }
        }
    }

    private var sessionHeader: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Evlilik Planı")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                Text("Ortak seçeneklerinizi burada toplayın.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                UIPasteboard.general.string = store.sessionCode
            } label: {
                HStack(spacing: 8) {
                    Text(store.sessionCode)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 12, weight: .semibold))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule().fill(Color(.secondarySystemBackground))
                )
                .overlay(
                    Capsule().strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)

            Button {
                showManageCategories = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 8)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "sparkles")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.secondary)
            Text("Henüz bir seçenek yok")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
            Text("Mekan, eşya veya masraf seçeneklerini ekleyerek başlayın.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
        }
    }
    
    private var categoryFilterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button {
                    selectedCategoryId = nil
                } label: {
                    Text("Tüm Kategoriler")
                        .font(.footnote.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule().fill(selectedCategoryId == nil ? Color(.tertiarySystemFill) : Color(.secondarySystemBackground))
                        )
                        .overlay(
                            Capsule().strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)

                ForEach(store.categories) { cat in
                    Button {
                        selectedCategoryId = cat.id
                    } label: {
                        Text(cat.name)
                            .font(.footnote.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(selectedCategoryId == cat.id ? Color(.tertiarySystemFill) : Color(.secondarySystemBackground))
                            )
                            .overlay(
                                Capsule().strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
    }

}
