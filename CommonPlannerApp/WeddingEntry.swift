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

enum PaymentOption: String, Codable, CaseIterable, Hashable {
    case peşin = "Peşin"
    case taksit1 = "1 Taksit"
    case taksit2 = "2 Taksit"
    case taksit3 = "3 Taksit"
    case taksit4 = "4 Taksit"
    case taksit5 = "5 Taksit"
    case taksit6 = "6 Taksit"
    case taksit7 = "7 Taksit"
    case taksit8 = "8 Taksit"
    case taksit9 = "9 Taksit"
    case taksit10 = "10 Taksit"
    case taksit11 = "11 Taksit"
    case taksit12 = "12 Taksit"
}

struct WeddingEntry: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var categoryId: UUID
    var price: Decimal
    var paymentOption: PaymentOption
    var note: String?
    var link: String?
    var photos: [Data] = []
    var status: WeddingEntryStatus
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        categoryId: UUID,
        price: Decimal,
        paymentOption: PaymentOption = .peşin,
        note: String? = nil,
        link: String? = nil,
        photos: [Data] = [],
        status: WeddingEntryStatus = .candidate,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.categoryId = categoryId
        self.price = price
        self.paymentOption = paymentOption
        self.note = note
        self.link = link
        self.photos = photos
        self.status = status
        self.createdAt = createdAt
    }
}

