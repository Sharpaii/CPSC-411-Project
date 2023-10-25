//
//  ScheduleViews.swift
//  ScheduleApp
//
//  Created by Madeline Sharpe on 10/24/23.
//

import SwiftUI

struct AvailableTimes: View{
    @EnvironmentObject var manager: ScheduleManager
    var body: some View {
        VStack{
            Text("There are currently no available times that match.")
        }
    }
}

struct EditableSchedulesList: View {
    @EnvironmentObject var manager: ScheduleManager
    var body: some View {
        VStack {
            // TODO: Model 3 - Add the EditButton here
            EditButton()
            List {
                /// ForEach requires each element in the collection it traverses to be Identifiable
                ForEach(manager.schedules) {
                                    schedule in
                                    VStack (alignment: .leading) {
                                        Text(schedule.person)
                                            .font(.largeTitle)
                                        Text(schedule.dT)
                                            .font(.caption)
                                    }
                // TODO: Model 2 - Add the onDelete method below
                                }.onDelete {
                                    offset in
                                    manager.schedules.remove(atOffsets: offset)
                                }
                // TODO: Model 3 - Add the onMove method below
                                .onMove {
                                    offset, index in
                                    manager.schedules.move(fromOffsets: offset, toOffset: index)
                                }

            }
        }
    }
}

struct AddDateTime: View {
    //@SceneStorage("person") var person: String = ""
    //@SceneStorage("dT") var dT: String = ""
    @EnvironmentObject var manager: ScheduleManager
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
