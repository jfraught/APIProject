//
//  Rep.swift
//  APIProject
//
//  Created by Jordan Fraughton on 4/26/24.
//

import Foundation

struct Rep: Codable {
    var name: String
    var party: String
    var link: URL
}

struct RepSearchResponse: Codable {
    let results: [Rep]
}
