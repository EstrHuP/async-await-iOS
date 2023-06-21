//
//  NewsSourceListView.swift
//  AsyncAwaitExample
//
//  Created by EstrHuP on 21/6/23.
//

import SwiftUI

struct NewsSourceListView: View {
    
    @StateObject private var newsSourceListViewModel = NewsSourceListViewModel()
    
    var body: some View {
        NavigationView {
            List(newsSourceListViewModel.newsSources, id: \.id) { newsSource in
                NavigationLink(destination: NewsListView(newsSource: newsSource)) {
                    NewsSourceCell(newsSource: newsSource)
                }
            }
            .listStyle(.plain)
            //ios15 for async await func
            .task {
                await newsSourceListViewModel.getSources()
            }
            .navigationTitle("News Sources")
            .navigationBarItems(trailing: Button(action: {
                // refresh the news
            }, label: {
                Image(systemName: "arrow.clockwise.circle")
            }))
        }
    }
}

struct NewsSourceListScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewsSourceListView()
    }
}

struct NewsSourceCell: View {
    
    let newsSource: NewsSourceViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(newsSource.name)
                .font(.headline)
            Text(newsSource.description)
        }
    }
}
