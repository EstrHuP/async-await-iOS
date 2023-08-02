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
    
    @Published var randomImages: [RandomImageViewModel] = [] //refresh automatically
    
    func getRandomImages(ids: [Int]) async {
        
        let webService = RandomWebservice()
        randomImages = []
        
        do {
            //much faster
            try await withThrowingTaskGroup(of: (Int, RandomImage).self, body: { group in
                
                for id in ids {
                    group.async {
                        return (id, try await webService.getRandomImage(id: id))
                    }
                }
                
                for try await (_, randomImage) in group {
                    randomImages.append(RandomImageViewModel(randomImage: randomImage))
                }
            })
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
