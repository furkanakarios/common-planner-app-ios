//
//  WeddingEntry.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import Foundation

enum WeddingEntryStatus: String, Codable, CaseIterable {
    case candidate
    case selected
    case eliminated
}

struct WeddingCategory: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

struct WeddingEntry: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var categoryId: UUID
    var price: Decimal
    var note: String?
    var link: String?
    var status: WeddingEntryStatus
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        categoryId: UUID,
        price: Decimal,
        note: String? = nil,
        link: String? = nil,
        status: WeddingEntryStatus = .candidate,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.categoryId = categoryId
        self.price = price
        self.note = note
        self.link = link
        self.status = status
        self.createdAt = createdAt
    }
}
