//
//  NewsSourceListViewModel.swift
//  AsyncAwaitExample
//
//  Created by EstrHuP on 21/6/23.
//

import Foundation

class NewsSourceListViewModel: ObservableObject {
    
    @Published var newsSources: [NewsSourceViewModel] = []
    
    func getSources() async {
        //async await
        do {
            let newsSources = try await NewsWebService().fetchSourcesAsync(url: Constants.Urls.sources)
            DispatchQueue.main.async {
                self.newsSources = newsSources.map(NewsSourceViewModel.init)
            }
        } catch {
            print(error)
        }
        
        //without async await
        /* NewsWebService().fetchSources(url: Constants.Urls.sources) { result in
            switch result {
                case .success(let newsSources):
                    DispatchQueue.main.async {
                        self.newsSources = newsSources.map(NewsSourceViewModel.init)
                    }
                case .failure(let error):
                    print(error)
            }
        } */
    }
}

struct NewsSourceViewModel {
    
    fileprivate var newsSource: NewsSource
    
    var id: String {
        newsSource.id
    }
    
    var name: String {
        newsSource.name
    }
    
    var description: String {
        newsSource.description
    }
    
    static var `default`: NewsSourceViewModel {
        let newsSource = NewsSource(id: "abc-news", name: "ABC News", description: "This is ABC news")
        return NewsSourceViewModel(newsSource: newsSource)
    }
}
