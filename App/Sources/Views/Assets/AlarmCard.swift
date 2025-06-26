//
//  AlarmCard.swift
//  ReClockSync
//
//  Created by Arya Hanif on 17/06/25.
//

import SwiftUI

struct DayOfWeekView: View {
    let days = ["S", "M", "T", "W", "T", "F", "S"]
    let selectedDays: [Day] // Read-only, no binding needed

    // Convert Day enum array to boolean array
    private var dayEnabled: [Bool] {
        return [
            selectedDays.contains(.sunday),
            selectedDays.contains(.monday),
            selectedDays.contains(.tuesday),
            selectedDays.contains(.wednesday),
            selectedDays.contains(.thursday),
            selectedDays.contains(.friday),
            selectedDays.contains(.saturday),
        ]
    }

    var body: some View {
        HStack {
            ForEach(0 ..< days.count, id: \.self) { index in
                Text(days[index])
                    .foregroundColor(dayEnabled[index] ? .primary : .gray)
                    .font(.system(size: 10))
            }
        }
    }
}

struct AlarmCard: View {
    var alarm: Alarm
    @State private var isOn = true

    init(alarm: Alarm) {
        self.alarm = alarm
        _isOn = State(initialValue: alarm.isOn)
    }

    @State private var alarmTime = Date()

    var body: some View {
        HStack {
            Text("\(alarm.time, style: .time)") // Display time in HH:mm format
                .font(.title)

            Spacer()
            DayOfWeekView(selectedDays: alarm.selectedDays)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding(.all, 2)
    }
}

struct ConfigurationView: View {
    @Binding var alarmTime: Date
    @Binding var isOn: Bool

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Alarm Time", selection: $alarmTime, displayedComponents: .hourAndMinute)
                Toggle("Turn On", isOn: $isOn)
            }
            .navigationTitle("Configure Alarm")
            .navigationBarItems(trailing: Button("Done") {
                // Close configuration
            })
        }
    }
}

// #Preview {
//    AlarmCard(alarm: Alarm(id: UUID(),time: Date(), keyDevice:["ip15","ip16"],tones:"marry",isOn: true))
//        .preferredColorScheme(.dark)
// }
