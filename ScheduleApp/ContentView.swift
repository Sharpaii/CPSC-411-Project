//  ===========================================================================
//  ContentView.swift
//  ScheduleApp
//  ===========================================================================
//  Created by: Swifter Sweeper Jets (SSJ)
//  Group Members: Ethan Stupin, Madeleine Sharpe, Neema Tabarani, Rey Urquiza
//  ===========================================================================

import SwiftUI

// Bottom tab to view separate pages
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

// View to see the bottom tab
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//  ===== END OF FILE =========================================================
