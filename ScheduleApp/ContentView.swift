import SwiftUI


struct ContentView: View {
    @StateObject var manager = ScheduleManager()
    
    var body: some View {
        TabView {
            AddDateTime()
                .tabItem {
                    Image(systemName: "plus")
                    Text("Add Time")
                }
            EditableSchedulesList()
                .tabItem {
                    Image(systemName: "clock")
                    Text("Schedules List")
                }
            AvailableTimes()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Available Times")
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
