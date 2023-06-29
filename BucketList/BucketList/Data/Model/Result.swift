//
//  Result.swift
//  BucketList
//
//  Created by BPS.Dev01 on 6/28/23.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [String: Page]
}

struct Page: Codable, Comparable, Equatable {

    let pageid: Int
    let title: String
    let terms: Terms?
    
    var description: String {
        terms?.termsDescription.first ?? "No description"
    }
    
    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
    
    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.pageid == rhs.pageid
    }
}

struct Terms: Codable {
    let termsDescription: [String]

    enum CodingKeys: String, CodingKey {
        case termsDescription = "description"
    }
}
