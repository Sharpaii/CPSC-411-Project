//
//  ContentView.swift
//  ScheduleApp
//
//  Created by Madeline Sharpe on 10/19/23.
//

import SwiftUI

struct ContentView: View {
    @State var startTime = Date()
    @State var endTime = Date()
    var closedRange = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
    
    func formatDate() -> String {
        let sComponents = Calendar.current.dateComponents([.hour, .minute, .day, .year, .month], from: startTime)
        let sHour = sComponents.hour ?? 0
        let sMinute = sComponents.minute ?? 0
        let sDay = sComponents.day ?? 0
        let sMonth = sComponents.month ?? 0
        let sYear = sComponents.year ?? 0
        
        let eComponents = Calendar.current.dateComponents([.hour, .minute], from: endTime)
        let eHour = eComponents.hour ?? 0
        let eMinute = eComponents.minute ?? 0
        
        if (eHour < sHour){
            return "Invalid time"
        }
        else {
            return "\(sMonth)/\(sDay)/\(sYear) [\(sHour):\(sMinute) - \(eHour):\(eMinute)]"
        }
    }
    
    var body: some View {
        Form {
            Section(header:Text("Start Time")) {
                DatePicker("Pick a date: ", selection: $startTime)
            }
            Section(header:Text("End Time")) {
                DatePicker("Pick a time: ", selection: $endTime, displayedComponents: .hourAndMinute)
            }
            Section(header: Text("Result")) {
                Text(formatDate())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
