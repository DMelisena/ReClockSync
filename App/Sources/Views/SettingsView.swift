//
//  SettingsView.swift
//  ReClockSync
//
//  Created by Arya Hanif on 18/06/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var keyDevice = "Iphone"
    @State private var beforeSleepReminder = "1 hour"
    @State private var defaultAlarmTone = "For River"
    @State private var randomizedAlarm = true
    @State private var consecutiveMode = true
    @State private var allowSnooze = true
    @State private var defaultTimezone = true
    @State private var snoozeInterval = "5 mins"
    @State private var selectedTimeZone = TimeZone.current.identifier
    @State private var selectedMinutes = 0

    let timeZones = TimeZone.knownTimeZoneIdentifiers
    let alarmSounds = ["Chimes", "Radar", "Beacon", "Marimba", "Circuit"]
    let keyDevices = ["Iphone", "Mac", "IWatch"]
    let beforeSleepReminders = ["5 minutes", "10 minutes", "30 minutes", "1 hour", "2 hours"]
    let defaultAlarmTones = ["For River", "music 1", "music 2", "music 3", "music 4"]
    let snoozeOptions = ["disabled", "5 minutes", "10 minutes", "15 minutes"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Settings")) {
                    Picker("Key Device", selection: $keyDevice) {
                        ForEach(keyDevices, id: \.self) { sound in
                            Text(sound)
                        }
                    }
                    Picker("Sleep Reminder", selection: $beforeSleepReminder) {
                        ForEach(beforeSleepReminders, id: \.self) { sound in
                            Text(sound)
                        }
                    }
                    Picker("Default Ringtone", selection: $defaultAlarmTone) {
                        ForEach(defaultAlarmTones, id: \.self) { sound in
                            Text(sound)
                        }
                    }
                    Toggle("Randomize Alarm", isOn: $randomizedAlarm)
                    Toggle("Allow Snooze", isOn: $allowSnooze)
                    if allowSnooze{
                        Picker("Minutes", selection: $selectedMinutes) {
                            ForEach(Array(stride(from: 0, to: 60, by: 5)), id: \.self) { minute in
                                Text("\(minute) min").tag(minute)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    Toggle("Consecutive Mode", isOn: $consecutiveMode)
                    Toggle("Use Default Timezone", isOn: $defaultTimezone)
                    if !defaultTimezone{
                        Picker("", selection: $selectedTimeZone) {
                            ForEach(timeZones, id: \.self) { zone in
                                Text(zone).tag(zone)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    Button("Customize Button") { }
                        .padding(.all, 6)
                }
                .padding(.all, 6)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}
