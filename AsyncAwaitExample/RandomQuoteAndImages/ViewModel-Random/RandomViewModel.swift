//
//  RandomViewModel.swift
//  AsyncAwaitExample
//
//  Created by EstrHuP on 23/6/23.
//

import Foundation
import UIKit

@MainActor
class RandomViewModel: ObservableObject {
    
    @Published var randomImages: [RandomImageViewModel] = []
    
    func getRandomImages(ids: [Int]) async {
        do {
            let randomImages = try await RandomWebservice().getRandomImages(ids: ids)
            self.randomImages = randomImages.map(RandomImageViewModel.init)
        } catch {
            print(error)
        }
    }
}

struct RandomImageViewModel: Identifiable {
    
    let id = UUID()
    fileprivate let randomImage: RandomImage
    
    var image: UIImage? {
        UIImage(data: randomImage.image)
    }
    
    var quote: String {
        randomImage.quote.content
    }
}
