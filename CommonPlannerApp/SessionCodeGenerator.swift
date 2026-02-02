//
//  SessionCodeGenerator.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import Foundation

enum SessionCodeGenerator {
    static func generate() -> String {
        // 6 haneli rastgele sayı, 000000–999999 arası, baştaki sıfırlar korunur
        let number = Int.random(in: 0...999_999)
        return String(format: "%06d", number)
    }
}
