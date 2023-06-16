//
//  ExpenseItem.swift
//  iExpense
//
//  Created by BPS.Dev01 on 6/15/23.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
