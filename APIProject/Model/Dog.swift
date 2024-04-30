//
//  Dog.swift
//  APIProject
//
//  Created by Jordan Fraughton on 4/25/24.
//

import Foundation
import UIKit

struct Dog: Codable {
    var imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "message"
    }
}
