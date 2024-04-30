//
//  DogController.swift
//  APIProject
//
//  Created by Jordan Fraughton on 4/25/24.
//

import Foundation
import UIKit

class DogController {
    enum DogError: Error, LocalizedError {
        case dogNotFound
        case imageDataMissing
    }
    
    func fetchDogPhoto(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
            throw DogError.imageDataMissing
        }
        
        guard let image = UIImage(data: data) else {
            throw DogError.imageDataMissing
        }
        
        return image
    }
    
    func fetchDogInfo() async throws -> Dog {
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
       
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
            throw DogError.dogNotFound
        }
        
        let jsonDecoder = JSONDecoder()
        let dog = try jsonDecoder.decode(Dog.self, from: data)
        
        return dog
    }
}
