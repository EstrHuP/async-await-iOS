//
//  RandomImage.swift
//  AsyncAwaitExample
//
//  Created by EstrHuP on 23/6/23.
//

import Foundation

struct RandomImage: Decodable {
    let image: Data
    let quote: Quote
}

struct Quote: Decodable {
    let content: String
}
