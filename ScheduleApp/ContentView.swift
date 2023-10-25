//
//  ContentView.swift
//  ScheduleApp
//
//  Created by Madeline Sharpe on 10/19/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var manager = ScheduleManager()
    var body: some View {
        TabView {
            AvailableTimes()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Available Times")
                }
            EditableSchedulesList()
                .tabItem {
                    Image(systemName: "clock")
                    Text("Schedules List")
                }
            AddDateTime()
                .tabItem {
                    Image(systemName: "plus")
                    Text("Add Time")
                }
        }
        .environmentObject(manager)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
