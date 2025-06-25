@_exported import Inject
import SwiftUI

struct ContentView: View {
    @ObserveInjection var inject // This is the correct way to use it
    @State var showingSettingsSheet = false
    @State private var showingAddAlarmSheet = false

    private let defaults = UserDefaults.standard

    var startValue = CGFloat(UserDefaults.standard.double(forKey: "startAngle"))
    var endValue = CGFloat(UserDefaults.standard.double(forKey: "endAngle"))

    @State private var alarms: [Alarm] = []

    let userDefaultsKey = "alarms" // Must be the SAME key used for saving
    var body: some View {
        VStack {
            ClockSlider(startAngle: startValue, endAngle: endValue)
            AlarmCards(alarms: $alarms)
            HStack { // {{{
                // Settings button
                Button(action: {
                    showingSettingsSheet = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .clipShape(Circle())
                }
                .sheet(isPresented: $showingSettingsSheet) {
                    SettingsView()
                        .preferredColorScheme(.dark)
                }
                Spacer()

                // Plus button
                Button(action: {
                    showingAddAlarmSheet = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .clipShape(Circle())
                }
                .sheet(isPresented: $showingAddAlarmSheet) {
                    AddAlarmView(showingAddAlarmSheet: $showingAddAlarmSheet, alarms: $alarms)
                }
            } // }}}
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
            Spacer()
        }
        .onAppear {
            loadAlarms()
        }
    }

    func loadAlarms() {
        if let savedData = UserDefaults.standard.data(forKey: "alarms"),
           let decoded = try? JSONDecoder().decode([Alarm].self, from: savedData)
        {
            alarms = decoded
        }
        print("AlarmLoaded")
    }
}
