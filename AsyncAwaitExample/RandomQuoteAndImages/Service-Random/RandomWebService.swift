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
        
        //task group for more concurrencly
        try await withThrowingTaskGroup(of: (Int, RandomImage).self, body: { group in
            
            //get ids of image
            for id in ids {
                group.addTask { [self] in
                    return (id, try await self.getRandomImage(id: id))
                }
            }
            
            //get random images
            for try await (_, randomImage) in group {
                print(randomImage)
                randomImages.append(randomImage)
            }
        })
        return randomImages
    }
    
    func getRandomImage(id: Int) async throws -> RandomImage {
        
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
