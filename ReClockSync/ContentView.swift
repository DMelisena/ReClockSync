@_exported import Inject
import SwiftUI

struct ContentView: View {
    @ObservedObject private var io = Inject.observer // swiftlint:disable:this identifier_name
    private let defaults = UserDefaults.standard
    var startValue = CGFloat(UserDefaults.standard.double(forKey: "startAngle"))
    var endValue = CGFloat(UserDefaults.standard.double(forKey: "endAngle"))

    var body: some View {
        VStack {
            ClockSlider(startAngle: startValue, endAngle: endValue)
            Image(systemName: "apple.logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .imageScale(.large)
                .foregroundStyle(.black)

            Text("test")
                .font(.largeTitle)
                .fontDesign(.rounded)
                .fontWeight(.bold)
        }
        .padding()
        .enableInjection()
    }
}
