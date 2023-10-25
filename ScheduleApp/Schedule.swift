//
//  Times.swift
//  ScheduleApp
//
//  Created by Madeline Sharpe on 10/24/23.
//

import Foundation

class ScheduleManager: ObservableObject {
    @Published var schedules: [Schedule] = []
    
    init(){
        schedules.append(Schedule(person:"Bobby", dT:"TEST TIME"))
    }
}

struct Schedule: Identifiable {
    var id = UUID()
    var person: String
    var dT: String
}
