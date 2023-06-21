//
//  WebService.swift
//  AsyncAwaitExample
//
//  Created by EstrHuP on 21/6/23.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidData
    case decodingError
}

class NewsWebService {
    
    func fetchSourcesAsync(url: URL?) async throws -> [NewsSource] {
        guard let url = url else {
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let newsSourceResponse = try? JSONDecoder().decode(NewsSourceResponse.self, from: data)
        
        return newsSourceResponse?.sources ?? []
    }
    
    // without async await
    /* func fetchSources(url: URL?, completion: @escaping (Result<[NewsSource], NetworkError>) -> Void) {
        guard let url = url else {
            completion(.failure(.badUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            let newsSourceResponse = try? JSONDecoder().decode(NewsSourceResponse.self, from: data)
            completion(.success(newsSourceResponse?.sources ?? []))
            
        }
        .resume()
    } */
    
    //Use async throws to use the errors
    //Continuation with the success and error
    func fetchNewsAsync(sourceId: String, url: URL?) async throws -> [NewsArticle] {
        
        try await withCheckedThrowingContinuation { continuation in
            fetchNews(sourceId: sourceId, url: url) { result in
                switch result {
                case .success(let newsArticles):
                    continuation.resume(returning: newsArticles)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func fetchNews(sourceId: String, url: URL?, completion: @escaping (Result<[NewsArticle], NetworkError>) -> Void) {
        guard let url = url else {
            completion(.failure(.badUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            let newsArticleResponse = try? JSONDecoder().decode(NewsArticleResponse.self, from: data)
            completion(.success(newsArticleResponse?.articles ?? []))
        }
        .resume()
    }
}