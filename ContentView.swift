//
//  ContentView.swift
//  ScheduleApp
//
//  Created by Madeline Sharpe on 10/19/23.
//

import SwiftUI

struct ContentView: View {
    //@StateObject var manager = VolunteerManager()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("List of volunteers: ")
                    .font(.headline)
                    .padding(.bottom, 30)
                //Text(manager.volunteerList)
                    .padding(.bottom, 30)
                //NavigationLink(destination: VolunteerForm()) {
                //    Text("Add more volunteers")
                //        .bold()
                //        .modifier(ButtonDesign())
            }
                Spacer()
        }
    }//.environmentObject(manager)
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
