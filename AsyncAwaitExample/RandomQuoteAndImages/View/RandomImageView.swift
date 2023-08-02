//
//  RandomImageView.swift
//  AsyncAwaitExample
//
//  Created by EstrHuP on 23/6/23.
//

import SwiftUI

struct RandomImageView: View {
    
    @StateObject private var randomImageListVM = RandomViewModel()
    
    var body: some View {
        List(randomImageListVM.randomImages) { randomImage in
            HStack {
                randomImage.image.map {
                    Image(uiImage: $0)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                Text(randomImage.quote)
            }
        }.task {
            await randomImageListVM.getRandomImages(ids: Array(100...200))
        }
        .navigationTitle("Random Images/Quotes")
        .navigationBarItems(trailing: Button(action: {
            
            Task {
                await randomImageListVM.getRandomImages(ids: Array(100...200))
            }
            
        }, label: {
            Image(systemName: "arrow.clockwise.circle")
        }))
    }
}

struct RandomImageView_Previews: PreviewProvider {
    static var previews: some View {
        RandomImageView()
    }
}
