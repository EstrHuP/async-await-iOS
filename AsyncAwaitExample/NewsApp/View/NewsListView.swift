//
//  NewsListView.swift
//  AsyncAwaitExample
//
//  Created by EstrHuP on 21/6/23.
//

import SwiftUI

struct NewsListView: View {
    
    let newsSource: NewsSourceViewModel
    @StateObject private var newsArticleListViewModel = NewsArticleListViewModel()
    
    var body: some View {
        List(newsArticleListViewModel.newsArticles, id: \.id) { newsArticle in
            NewsArticleCell(newsArticle: newsArticle)
        }
        .listStyle(.plain)
        //ios15 async await
        .task {
            await newsArticleListViewModel.getNewsBy(sourceId: newsSource.id)
        }
        .navigationTitle(newsSource.name)
    }
}

struct NewsListScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView(newsSource: .default)
    }
}

struct NewsArticleCell: View {
    
    let newsArticle: NewsArticleViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: newsArticle.urlToImage) { image in
                image.resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
            } placeholder: {
                ProgressView("Loading...")
                    .frame(maxWidth: 100, maxHeight: 100)
            }
            
            VStack {
                Text(newsArticle.title)
                    .fontWeight(.bold)
                Text(newsArticle.description)
            }
        }
    }
}
