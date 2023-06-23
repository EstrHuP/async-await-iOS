//
//  RandomWebService.swift
//  AsyncAwaitExample
//
//  Created by EstrHuP on 23/6/23.
//

import Foundation

enum RandomNetworkError: Error {
    case badUrl
    case invalidImageId(Int)
    case decodingError
}

class RandomWebservice {
    
    func getRandomImages(ids: [Int]) async throws -> [RandomImage] {
        
        var randomImages: [RandomImage] = []
        
        for id in ids {
            
            let randomImage = try await getRandomImage(id: id)
            randomImages.append(randomImage)
        }
        return randomImages
    }
    
    private func getRandomImage(id: Int) async throws -> RandomImage {
        
        guard let url = RandomConstants.Urls.getRandomImageUrl() else {
                   throw NetworkError.badUrl
        }
        
        guard let randomQuoteUrl = RandomConstants.Urls.randomQuoteUrl else {
                   throw NetworkError.badUrl
        }
        
        async let (imageData, _) = URLSession.shared.data(from: url)
        async let (randomQuoteData, _) = URLSession.shared.data(from: randomQuoteUrl)
        
        guard let quote = try? JSONDecoder().decode(Quote.self, from: try await randomQuoteData) else {
            throw NetworkError.decodingError
        }
        
        return RandomImage(image: try await imageData, quote: quote)
    }
    
}
