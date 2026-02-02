//
//  ManageCategoriesView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

struct ManageCategoriesView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: WeddingSessionStore
    @State private var newCategoryName: String = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Yeni Kategori") {
                    HStack {
                        TextField("Kategori adı", text: $newCategoryName)
                        Button {
                            store.addCategory(name: newCategoryName)
                            newCategoryName = ""
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }

                Section("Kategoriler") {
                    ForEach(store.categories) { cat in
                        Text(cat.name)
                    }
                    .onDelete(perform: store.deleteCategories)
                    .onMove(perform: store.moveCategories)
                }
            }
            .navigationTitle("Kategoriler")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Kapat") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}
