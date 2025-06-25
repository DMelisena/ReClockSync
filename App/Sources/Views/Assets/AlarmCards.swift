import Foundation
import SwiftUI

struct AlarmCards: View {
    @Binding var alarms: [Alarm]
    var body: some View {
        VStack {
            List { ForEach(alarms.indices, id: \.self) { index in
                AlarmCard(alarm: self.alarms[index])
            }
            }
            .padding(.top, -35)
            .listStyle(.grouped)
            .frame(minWidth: 0, maxWidth: .infinity)
        }
        .onAppear {
            if let savedData = UserDefaults.standard.data(forKey: "alarms"),
               let decoded = try? JSONDecoder().decode([Alarm].self, from: savedData)
            {
                print("====xxxxx=====")
                print(alarm)
//                alarms = decoded
                print("=====xxxxx===")
            }
        }

        .preferredColorScheme(.dark)
    }
}
