//
//  LaureateController.swift
//  APIProject
//
//  Created by Jordan Fraughton on 4/29/24.
//

import Foundation

enum LaureateControllerError: Error, LocalizedError {
    case laureatesNotFound
}

class LaruateController {
    func fetchLarautes(matching query: [String: String]) async throws -> Prizes {
        var urlComponents = URLComponents(string: "https://api.nobelprize.org/v1/prize.json")!
        urlComponents.queryItems = query.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        guard
            let httpResonse = response as? HTTPURLResponse,
            httpResonse.statusCode == 200 else {
            throw LaureateControllerError.laureatesNotFound
        }
        
        let jsonDecoder = JSONDecoder()
        let searchResponse = try jsonDecoder.decode(Prizes.self, from: data)
        
        return searchResponse
    }
}
