//  ===========================================================================
//  ScheduleViews.swift
//  ScheduleApp
//  ===========================================================================
//  Created by: Swifter Sweeper Jets (SSJ)
//  Group Members: Ethan Stupin, Madeleine Sharpe, Neema Tabarani, Rey Urquiza
//  ===========================================================================

import SwiftUI

// This is the page that shows the point of the project, which is the combined
// available time that everyone has inputted
struct AvailableTimes: View {
    @EnvironmentObject var manager: ScheduleManager
    
    @State private var date: String = ""
    @State private var timeInterval: String = ""
    @State private var people: [String] = []
    
    var body: some View {
        ZStack {
            // Shows a background image instead of color
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.75)

            VStack {
                VStack {
                    Text("Everyone can meet up during: ")
                        .font(.largeTitle)
                        .padding()
                    Text(date)
                        .font(.largeTitle)
                        .padding()
                    Text(timeInterval)
                        .font(.largeTitle)
                        .padding()
                }
                .padding()
                .background(Color.blue.opacity(0.5))
                .cornerRadius(10)

                VStack {
                    Text("Friends Participating: ")
                        .font(.largeTitle)
                    ForEach(people, id: \.self) { person in
                        Text("- \(person)")
                            .font(.largeTitle)
                    }
                }
                .padding()
                .background(Color.green.opacity(0.5))
                .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            if let freeTime = manager.calculateFreeTime() {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                date = dateFormatter.string(from: freeTime.0)
                
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "h:mm a"
                let startTime = timeFormatter.string(from: freeTime.0)
                let endTime = timeFormatter.string(from: freeTime.1)
                timeInterval = "\(startTime) - \(endTime)"
                
                people = manager.schedules.map { $0.person }
            } else {
                date = "No times match"
                timeInterval = "Try other days or times"
            }
        }
    }
}

//struct AvailableTimes: View {
//    @EnvironmentObject var manager: ScheduleManager
//
//    @State private var date: String = ""
//    @State private var timeInterval: String = ""
//    @State private var people: [String] = []
//
//    var body: some View {
//        ZStack {
//            // Shows a background image instead of color
//            Image("background")
//                .resizable()
//                .edgesIgnoringSafeArea(.all)
//                .opacity(0.75)
//
//            VStack {
//                Text("Everyone can meet up during: ")
//                    .padding()
//                    .background(Color.white.opacity(0.5))
//                    .cornerRadius(10)
//                    .font(.largeTitle)
//                Text(date)
//                    .padding()
//                    .background(Color.blue.opacity(0.5))
//                    .cornerRadius(10)
//                    .font(.largeTitle)
//                Text(timeInterval)
//                    .padding()
//                    .background(Color.blue.opacity(0.5))
//                    .cornerRadius(10)
//                    .font(.largeTitle)
//                Text("Friends Participating: ")
//                    .padding()
//                    .background(Color.green.opacity(0.5))
//                    .cornerRadius(10)
//                    .font(.largeTitle)
//                ForEach(people, id: \.self) { person in
//                    Text("- \(person)")
//                        .padding()
//                        .background(Color.green.opacity(0.5))
//                        .cornerRadius(10)
//                        .font(.largeTitle)
//                }
//            }
//            .padding()
//        }
//        .onAppear {
//            if let freeTime = manager.calculateFreeTime() {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "MM/dd/yyyy"
//                date = dateFormatter.string(from: freeTime.0)
//
//                let timeFormatter = DateFormatter()
//                timeFormatter.dateFormat = "HH:mm"
//                let startTime = timeFormatter.string(from: freeTime.0)
//                let endTime = timeFormatter.string(from: freeTime.1)
//                timeInterval = "\(startTime) - \(endTime)"
//
//                people = manager.schedules.map { $0.person }
//            } else {
//                date = "No times match"
//                timeInterval = "Try other days or times"
//            }
//        }
//    }
//}

// This page shows a list of names and times that have been entered
struct EditableSchedulesList: View {
    @EnvironmentObject var manager: ScheduleManager
    @State private var isEditing = false

    var body: some View {
        ZStack {
            // Set the background color here
            Color.gray.edgesIgnoringSafeArea(.all)

            VStack {
                Button(action: {
                    self.isEditing.toggle()
                }) {
                    Text(self.isEditing ? "Done" : "Edit")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                List {
                    Text("Time List")
                        .font(.largeTitle)
                        .padding()
                        .cornerRadius(10)
                    ForEach(manager.schedules.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(manager.schedules[index].person)
                                .font(.largeTitle)
                            Text(formatDate(date: manager.schedules[index].startTime))
                                .font(.caption)
                            Text(formatDate(date: manager.schedules[index].endTime))
                                .font(.caption)
                        }
                        // Alternating background colors for list rows
                        .listRowBackground(index.isMultiple(of: 2) ? Color.gray.opacity(0.05) : Color.black.opacity(0.05))
                    }
                    .onDelete(perform: isEditing ? removeRows : nil)
                    .onMove(perform: isEditing ? moveRows : nil)
                }
            }
        }
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy [HH:mm]"
        return formatter.string(from: date)
    }

    func removeRows(at offsets: IndexSet) {
        manager.schedules.remove(atOffsets: offsets)
    }

    func moveRows(from source: IndexSet, to destination: Int) {
        manager.schedules.move(fromOffsets: source, toOffset: destination)
    }
}

// This is the page for adding times to the timesheet
struct AddDateTime: View {
    @EnvironmentObject var manager: ScheduleManager
    @State private var name: String = ""
    @State private var startTime = Date()
    @State private var endTime = Date()

    // Visual portion for the add times page
    var body: some View {
        Form {
            Text("Add Your Free Time").font(.largeTitle).padding()
            Section(header: Text("Name")) {
                TextField("Enter your name", text: $name)
            }
            Section(header: Text("Start Time")) {
                DatePicker("Pick a date: ", selection: $startTime)
            }
            Section(header: Text("End Time")) {
                DatePicker("Pick a time: ", selection: $endTime, displayedComponents: .hourAndMinute)
            }
            Button("Save") {
                manager.addSchedule(person: name, startTime: startTime, endTime: endTime)
            }
        }
    }
}

//  ===== END OF FILE =========================================================
