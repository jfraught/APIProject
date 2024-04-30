//
//  Laureate.swift
//  APIProject
//
//  Created by Jordan Fraughton on 4/29/24.
//

import Foundation

struct Laureate: Codable {
    var firstname: String
    var surname: String
}

struct Category: Codable {
    var year: String
    var category: String
    var laureates: [Laureate]
}

struct Prizes: Codable {
    var prizes: [Category]
}

