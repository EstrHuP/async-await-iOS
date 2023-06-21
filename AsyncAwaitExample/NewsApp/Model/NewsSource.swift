//
//  NewsSource.swift
//  AsyncAwaitExample
//
//  Created by EstrHuP on 21/6/23.
//

import Foundation

struct NewsSourceResponse: Decodable {
    let sources: [NewsSource]
}

struct NewsSource: Decodable {
    let id: String
    let name: String
    let description: String
}
