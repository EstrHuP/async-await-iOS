//
//  CurrentDate.swift
//  AsyncAwaitExample
//
//  Created by EstrHuP on 15/6/23.
//

import Foundation

struct CurrentDate: Decodable, Identifiable {
    let id = UUID()
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
    }
}
