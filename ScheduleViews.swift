import SwiftUI

struct AvailableTimes: View {
    @EnvironmentObject var manager: ScheduleManager
    
    var body: some View {
        VStack {
            if manager.schedules.isEmpty {
                Text("There are no schedules available.")
            } else if manager.schedules.count == 1 {
                Text("There is only one schedule available, cannot compare.")
            } else {
                if let commonTime = manager.findCommonTimeForTwoSchedules() {
                    Text("Common Time: \(commonTime)")
                        .padding()
                } else {
                    Text("No common time found")
                        .padding()
                }
            }
        }
    }
}

struct EditableSchedulesList: View {
    @EnvironmentObject var manager: ScheduleManager
    
    var body: some View {
        VStack {
            EditButton()
            
            List {
                ForEach(manager.schedules) { schedule in
                    VStack(alignment: .leading) {
                        Text(schedule.person)
                            .font(.largeTitle)
                        Text(schedule.dT)
                            .font(.caption)
                    }
                }
                .onDelete { indices in
                    manager.schedules.remove(atOffsets: indices)
                }
                .onMove { indices, newOffset in
                    manager.schedules.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
        }
    }
}


struct AddDateTime: View {
    @EnvironmentObject var manager: ScheduleManager
    @State private var userName = ""
    @State private var timeAddedMessage = "" // State variable to control the message visibility
    @State private var startTime = Date()
    @State private var endTime = Calendar.current.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
    @State private var shouldClearFields = false
    
    func formatDate() -> String {
        let calendar = Calendar.current
        let sComponents = calendar.dateComponents([.hour, .minute, .day, .month, .year], from: startTime)
        let eComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        
        guard let sHour = sComponents.hour,
              let sMinute = sComponents.minute,
              let eHour = eComponents.hour,
              let eMinute = eComponents.minute,
              let sDay = sComponents.day,
              let sMonth = sComponents.month,
              let sYear = sComponents.year else {
            return "Invalid time"
        }
        
        let isValidTime = calendar.compare(startTime, to: endTime, toGranularity: .minute) == .orderedAscending
        
        if isValidTime {
            let formattedStartTime = String(format: "%02d:%02d", sHour, sMinute)
            let formattedEndTime = String(format: "%02d:%02d", eHour, eMinute)
            
            if startTime == endTime {
                return "Start and end time cannot be the same"
            } else {
                return "\(sMonth)/\(sDay)/\(sYear) [\(formattedStartTime) - \(formattedEndTime)]"
            }
        } else {
            return "Invalid time"
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Name")){
                TextField("Enter your name", text: $userName)
            }
            Section(header: Text("Please Enter Your Availability")){}
            Section(header: Text("Start Time")) {
                DatePicker("Pick a date/time: ", selection: $startTime)
            }
            Section(header: Text("End Time")) {
                DatePicker("Pick a time: ", selection: $endTime, displayedComponents: .hourAndMinute)
            }
            Section(header: Text("Result")) {
                Text(formatDate())
            }
            Button("Done") {
                let formattedTime = formatDate()
                if !formattedTime.contains("Invalid time") && !userName.isEmpty {
                    // Check if start time and end time are the same
                    let sameTime = startTime == endTime

                    if sameTime {
                        timeAddedMessage = "Start and end times cannot be the same."
                    } else {
                        let newSchedule = Schedule(person: userName, dT: formattedTime)
                        manager.schedules.append(newSchedule)
                        timeAddedMessage = "Time added!"
                        shouldClearFields = true
                        print("Time added!")
                    }
                } else {
                    timeAddedMessage = "Please enter a valid name and time."
                }
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { !timeAddedMessage.isEmpty },
            set: { _ in }
        )) {
            Alert(title: Text(timeAddedMessage), dismissButton: .default(Text("Okay")) {
                if shouldClearFields {
                    userName = ""
                    startTime = Date()
                    endTime = Calendar.current.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
                    shouldClearFields = false
                }
                timeAddedMessage = ""
            })
        }
    }
}
