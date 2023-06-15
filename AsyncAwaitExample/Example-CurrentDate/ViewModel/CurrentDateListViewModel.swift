//
//  CurrentDateListViewModel.swift
//  AsyncAwaitExample
//
//  Created by EstrHuP on 15/6/23.
//

import Foundation

@MainActor //all properties, funcs, inside MainActor be called on the main threath
class CurrentDateListViewModel: ObservableObject {
    
    @Published var currentDates: [CurrentDateViewModel] = []
    
    func populateDates() async {
        do {
            let currentDate = try await WebService().getDate()
            if let currentDate = currentDate {
                let currentDateViewModel = CurrentDateViewModel(currentDate: currentDate)
                self.currentDates.append(currentDateViewModel)
            }
        } catch {
            print(error)
        }
    }
}

struct CurrentDateViewModel {
    let currentDate: CurrentDate
    
    var id: UUID {
        currentDate.id
    }
    
    var date: String {
        currentDate.date
    }
}
