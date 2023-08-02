//
//  Constants.swift
//  AsyncAwaitExample
//
//  Created by EstrHuP on 23/6/23.
//

import Foundation

struct RandomConstants {
    
    struct Urls {
        static func getRandomImageUrl() -> URL? {
            return URL(string: "https://picsum.photos/200/300?uuid=\(UUID().uuidString)")
        }
        
        static let randomQuoteUrl: URL? = URL(string: "https://api.quotable.io/random")
    }
}
