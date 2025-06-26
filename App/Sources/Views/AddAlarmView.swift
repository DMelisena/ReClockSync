//
//  AddAlarmView.swift
//  ReClockSync
//
//  Created by Arya Hanif on 17/06/25.
//

import SwiftUI

#if os(iOS) // This makes the code inside of this to only compiled to final product if the target product is iOS
//     #if os(iOS) || os(watchOS) || os(tvOS)  WOULD ALSO WORK ON THIS

    enum Day: String, CaseIterable, Codable {
        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    }

    struct DaysPicker: View {
        @Binding var selectedDays: [Day]
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

    struct Alarm: Codable, Identifiable {
        let id: UUID
        var time: Date
        var keyDevice: [String]
        var tones: String
        var isOn: Bool
        var description: String {
            return "Alarm(device: \(keyDevice), tone: \(tones))"
        }

        var selectedDays: [Day]
    }

    struct AddAlarmView: View {
        @Binding var showingAddAlarmSheet: Bool
        @Binding var alarms: [Alarm]
        @State var selectedDays: [Day] = []
        @State private var alarmTime = Date()
        @State private var selectedTone = "For River"

        let tones = ["For River", "Chimes", "Radar", "Beacon", "Marimba"]
        let keyDevices = ["Iphone", "Mac", "IWatch"]

        @State private var keyDevice = "Iphone"
        @State private var defaultAlarmTone = "For River"

        var body: some View {
            NavigationStack {
                Form {
                    // Time Picker
                    Section(header: Text("Alarm Time")) {
                        DatePicker("Select Time", selection: $alarmTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel) // silent!
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
                        DaysPicker(selectedDays: $selectedDays)
                    }
                    .navigationTitle("Add Alarm")
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            let newAlarm = Alarm(id: UUID(), time: alarmTime, keyDevice: [keyDevice], tones: selectedTone, isOn: true, selectedDays: selectedDays)
                            alarms.append(newAlarm)
                            do {
                                let encoded = try JSONEncoder().encode(alarms)
                                UserDefaults.standard.set(encoded, forKey: "alarms")
                                print("==========")
                                print(encoded)
                                print("==========")
                                print("Saved alarms:", alarms)
                            } catch {
                                print("Error saving alarms to UserDefaults: \(error.localizedDescription)")
                            }
                            showingAddAlarmSheet = false
                        }
                    }
                }
                .onAppear {
                    if let savedData = UserDefaults.standard.data(forKey: "alarms"),
                       let decoded = try? JSONDecoder().decode([Alarm].self, from: savedData)
                    {
                        alarms = decoded
                    }
                }
            }
        }
    }
#endif
