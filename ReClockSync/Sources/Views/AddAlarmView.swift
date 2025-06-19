//
//  AddAlarmView.swift
//  ReClockSync
//
//  Created by Arya Hanif on 17/06/25.
//

import SwiftUI

enum Day: String, CaseIterable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

struct DaysPicker: View {
    @State private var selectedDays: [Day] = []
    var body: some View {
        HStack {
            ForEach(Day.allCases, id: \.self) { day in
                Text(String(day.rawValue.first!))
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(selectedDays.contains(day) ? Color.cyan.cornerRadius(10) : Color.gray.cornerRadius(10))
                    .onTapGesture {
                        if selectedDays.contains(day) {
                            selectedDays.removeAll(where: { $0 == day })
                        } else {
                            selectedDays.append(day)
                        }
                    }
            }
        }
    }
}

struct Alarm: Codable {
    var time: Date
    var keyDevice: [String]
    var tones: String
    var isOn: Bool
    var description: String {
        return "Alarm(device: \(keyDevice), tone: \(tones))"
    }
}

struct AddAlarmView: View {
    @State private var arrayOfAlarms: [Alarm] = []
    @Binding var showingAddAlarmSheet: Bool
    @State private var alarmTime = Date()
    @State private var selectedTone = "For River"
//    @State private var repeatEnabled = false
//    @State private var snoozeEnabled = true
//    @State private var snoozeInterval = 5

    let tones = ["For River", "Chimes", "Radar", "Beacon", "Marimba"]
//    let snoozeOptions = [5, 10, 15, 30]
//    let timeZones = TimeZone.knownTimeZoneIdentifiers
//    let alarmSounds = ["Chimes", "Radar", "Beacon", "Marimba", "Circuit"]
    let keyDevices = ["Iphone", "Mac", "IWatch"]
//    let beforeSleepReminders = ["5 minutes", "10 minutes", "30 minutes", "1 hour", "2 hours"]
//    let defaultAlarmTones = ["For River", "music 1", "music 2", "music 3", "music 4"]
//    let repeatOptions = ["Every Day", "Weekday", "Weekend", "other"]

    @State private var keyDevice = "Iphone"
    @State private var defaultAlarmTone = "For River"
//    @State private var beforeSleepReminder = "1 hour"
//    @State private var randomizedAlarm = true
//    @State private var consecutiveMode = true
//    @State private var allowSnooze = true
//    @State private var defaultTimezone = true
//    @State private var selectedTimeZone = TimeZone.current.identifier
//    @State private var selectedMinutes = 0
//    @State private var repeatOption = "Every Day"

    var body: some View {
        NavigationStack {
            Form {
                // Time Picker
                Section(header: Text("Alarm Time")) {
                    DatePicker("Select Time", selection: $alarmTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                    Picker("Key Device", selection: $keyDevice) {
                        ForEach(keyDevices, id: \.self) { sound in
                            Text(sound)
                        }
                    }
                    Picker("Tone", selection: $selectedTone) {
                        ForEach(tones, id: \.self) { tone in
                            Text(tone)
                        }
                    }
//                    Toggle("Repeat", isOn: $repeatEnabled)
//                    if repeatEnabled {
//                        Picker("Frequency", selection: $repeatOption) {
//                            ForEach(repeatOptions, id: \.self) { schedule in
//                                Text(schedule)
//                            }
//                            newAlarm.repeatOptions.append(repeatOption)
//                        }
//                        if repeatOption == "other" {
//                            DaysPicker()
//                        }
//                    }
//                    Toggle("Allow Snooze", isOn: $snoozeEnabled)
//
//                    if snoozeEnabled {
//                        Picker("Snooze Interval", selection: $snoozeInterval) {
//                            ForEach(snoozeOptions, id: \.self) { interval in
//                                Text("\(interval) minutes")
//                            }
//                        }
//                    }
//                    Toggle("Randomize Alarm Tone", isOn: $randomizedAlarm)
//                    Toggle("Consecutive Mode", isOn: $consecutiveMode)
//                    Toggle("Use Default Timezone", isOn: $defaultTimezone)
//                    if !defaultTimezone {
//                        Picker("", selection: $selectedTimeZone) {
//                            ForEach(timeZones, id: \.self) { zone in
//                                Text(zone).tag(zone)
//                            }
//                        }
//                        .pickerStyle(.menu)
//                    }
                }
                .navigationTitle("Add Alarm")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let newAlarm = Alarm(time: alarmTime, keyDevice: [keyDevice], tones: selectedTone, isOn: true)
                        arrayOfAlarms.append(newAlarm)

                        if let encoded = try? JSONEncoder().encode(arrayOfAlarms) {
                            UserDefaults.standard.set(encoded, forKey: "alarms")
                            print("Saved alarms:", arrayOfAlarms)
                        }
                        showingAddAlarmSheet = false
                    }
                }
            }
            .onAppear {
                if let savedData = UserDefaults.standard.data(forKey: "alarms"),
                   let decoded = try? JSONDecoder().decode([Alarm].self, from: savedData)
                {
                    arrayOfAlarms = decoded
                }
            }
        }
    }
}

// #Preview {
//    AddAlarmView(showingAddAlarmSheet: .constant(true))
//        .preferredColorScheme(.dark)
// }
