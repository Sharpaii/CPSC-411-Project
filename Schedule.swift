import Foundation

class ScheduleManager: ObservableObject {
    @Published var schedules: [Schedule] = []

    init() {
        schedules.append(Schedule(person: "Neema", dT: "12/08/2023 [14:00 - 15:00]"))
        schedules.append(Schedule(person: "Sahar", dT: "12/08/2023 [14:30 - 15:00]"))
    }
    
    func findCommonTimeForTwoSchedules() -> String? {
        guard schedules.count == 2 else {
            return nil // Only two schedules should be compared
        }

        if let commonTime = findCommonTime(scheduleA: schedules[0], scheduleB: schedules[1]) {
            return commonTime
        }

        return nil // No common time found
    }


    func findCommonTime(scheduleA: Schedule, scheduleB: Schedule) -> String? {
        guard let startA = extractTime(from: scheduleA.dT),
              let startB = extractTime(from: scheduleB.dT) else {
            return nil
        }
        
        print("Start A: \(startA)")
        print("Start B: \(startB)")
        
        let commonStart = max(startA.start, startB.start)
        let commonEnd = min(startA.end, startB.end)
        
        if commonStart < commonEnd {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            let commonDate = dateFormatter.string(from: commonStart)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            let startTime = timeFormatter.string(from: commonStart)
            let endTime = timeFormatter.string(from: commonEnd)
            
            return "\(commonDate) [\(startTime) - \(endTime)]"
        }
        
        return nil
    }


    func extractTime(from schedule: String) -> (start: Date, end: Date)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy '[HH:mm - HH:mm]'"
        
        guard let startIndex = schedule.range(of: "[")?.upperBound,
              let endIndex = schedule.range(of: "]")?.lowerBound else {
            return nil
        }
        
        let timeSlot = String(schedule[startIndex..<endIndex])
        
        let timeComponents = timeSlot.components(separatedBy: " - ")
        
        guard timeComponents.count == 2,
              let startTime = dateFormatter.date(from: "\(timeComponents[0])"),
              let endTime = dateFormatter.date(from: "\(timeComponents[1])") else {
            return nil
        }
        
        return (startTime, endTime)
    }

    func isEarlierCommonTime(_ time1: String, than time2: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy '[HH:mm - HH:mm]'"
        
        if let date1 = dateFormatter.date(from: time1),
           let date2 = dateFormatter.date(from: time2) {
            return date1 < date2
        }
        
        return false
    }
}

struct Schedule: Identifiable {
    var id = UUID()
    var person: String
    var dT: String
}
