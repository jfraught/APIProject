//
//  RepController.swift
//  APIProject
//
//  Created by Jordan Fraughton on 4/26/24.
//

import Foundation

enum RepControllerError: Error, LocalizedError {
    case repNotFound
}

class RepController {
    func fetchItems(matching query: [String: String]) async throws -> [Rep] {
        var urlComponents = URLComponents(string: "https://whoismyrepresentative.com/getall_mems.php")!
        urlComponents.queryItems = query.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        urlComponents.queryItems?.append(URLQueryItem(name: "output", value: "json"))
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
    
        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
            throw RepControllerError.repNotFound
        }
        
        let jsonDecoder = JSONDecoder()
        let searchResponse = try jsonDecoder.decode(RepSearchResponse.self, from: data)
        return searchResponse.results
    }
}
