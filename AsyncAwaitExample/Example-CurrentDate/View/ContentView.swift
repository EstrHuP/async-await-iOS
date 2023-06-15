//
//  ContentView.swift
//  AsyncAwaitExample
//
//  Created by EstrHuP on 13/6/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var currentDateListVM = CurrentDateListViewModel()
   
    var body: some View {
        NavigationView {
            List(currentDateListVM.currentDates, id: \.id) { currentDate in
                Text(currentDate.date)
            }.listStyle(.plain)
            
            .navigationTitle("Dates")
            .navigationBarItems(trailing: Button(action: {
                // async { await populateDates() }
                //iOS 15
                Task.init(operation: {
                    await currentDateListVM.populateDates()
                })
            }, label: {
                Image(systemName: "arrow.clockwise.circle")
            }))
        }
        //iOS 15
        .task {
            await currentDateListVM.populateDates()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
