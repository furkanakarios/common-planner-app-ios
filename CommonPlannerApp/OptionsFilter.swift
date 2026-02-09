//
//  OptionsFilter.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 9.02.2026.
//

import Foundation

enum OptionsFilter: String, CaseIterable, Hashable {
    case all = "Tümü"
    case candidate = "Aday"
    case selected = "Seçilen"
    case eliminated = "Elenen"
}
