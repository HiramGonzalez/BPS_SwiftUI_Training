//
//  Card.swift
//  Flashzilla
//
//  Created by BPS.Dev01 on 7/5/23.
//

import Foundation


struct Card: Codable, Hashable {
    //var id = UUID()
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who played the 13th doctor in Doctor Who?", answer: "Jodie Whittaker")
}
