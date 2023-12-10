//  ===========================================================================
//  Times.swift
//  ScheduleApp
//  ===========================================================================
//  Created by: Swifter Sweeper Jets (SSJ)
//  Group Members: Ethan Stupin, Madeleine Sharpe, Neema Tabarani, Rey Urquiza
//  ===========================================================================

import Foundation
import SwiftUI

// Struct to handle incoming data from time entry page
struct Schedule: Identifiable {
    var id = UUID()
    var person: String
    var startTime: Date
    var endTime: Date
}

// Format inputted dates and calculate the free time between the dates
class ScheduleManager: ObservableObject {
    @Published var schedules: [Schedule] = []

    // Format time inputs and add to struct
    func addSchedule(person: String, startTime: Date, endTime: Date) {
        if endTime < startTime {
            // Create an alert when end time is before start time
            let alert = UIAlertController(title: "Invalid Entry", message: "End time cannot be before start time.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
            
            // Present the alert
            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    rootViewController.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let newSchedule = Schedule(person: person, startTime: startTime, endTime: endTime)
            schedules.append(newSchedule)

            // Create an alert when data has been entered successfully
            let alert = UIAlertController(title: "Your Time Has Been Added", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            
            // Present the alert
            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    rootViewController.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    // Calculate the latest start date and earliest end date
    func calculateFreeTime() -> (Date, Date)? {
        guard !schedules.isEmpty else { return nil }

        var latestStart = schedules[0].startTime
        var earliestEnd = schedules[0].endTime

        for schedule in schedules {
            if schedule.startTime > latestStart {
                latestStart = schedule.startTime
            }
            if schedule.endTime < earliestEnd {
                earliestEnd = schedule.endTime
            }
        }

        // If the latest start time is later than the earliest end time, return nil
        if latestStart > earliestEnd {
            return nil
        }

        // Return the time interval everyone falls between
        return (latestStart, earliestEnd)
    }
}

//  ===== END OF FILE =========================================================
