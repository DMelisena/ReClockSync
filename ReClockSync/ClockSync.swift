//
//  ClockSync.swift
//  ReClockSync
//
//  Created by Arya Hanif on 17/06/25.
//
import SwiftUI

enum SliderLockType { // Which slider is being moved. so if start is clicked, it would be the only deg value that could be changed
    case none, start, end
}

struct ClockSlider: View {
    // Default State (pi for half circle value, - to go left)
    // @State is needed if variable affect the view directly. (hot reload & view debugging purpose)
    
    private let defaults = UserDefaults.standard
    @State private var startAngle: CGFloat
    @State private var endAngle: CGFloat
    
    init(startAngle: CGFloat, endAngle: CGFloat) {
        let loadedStartAngle = defaults.object(forKey: "startAngle") as? CGFloat ?? -CGFloat.pi / 2

        let loadedEndAngle = defaults.object(forKey: "endAngle") as? CGFloat ?? CGFloat.pi / 2 * 1.5
        
        _startAngle = State(initialValue: loadedStartAngle)
        _endAngle = State(initialValue: loadedEndAngle)
        
    }
    
    @State private var sliderLock: SliderLockType = .none

    // The size of the slider
    // let = js const (immutable, can't be modified)
    // private => code only work on this struct (class), because the name could be used on other codes
    private let sliderDiameter: CGFloat = 230
    private let knobDiameter: CGFloat = 75
    private let lineWidth: CGFloat = 20 // purple bar thickness
    /* *pi /180 */
    private let min5Snap: CGFloat = 360 / 12 / 12 // Snap to 5 minutes interval (12 hours and 60mins/5)

    // if var turned into private var, you would not be able to call the variable from inside of the struct to outside.
    // example => clockslider = ClockSlider()
    // Text("\(clockslider.sliderDiameterAddWidth)")
    // this would then return the value of slider diameter value
    var sliderDiameterAddWidth: CGFloat {
        sliderDiameter + (lineWidth * 3)
        // need FINE TUNE when changing sliderDiameter or lineWidth
    }

    var durationMinutes: Int {
        let twoPi = CGFloat.pi * 2 // full circle in rads
        var difference = endAngle - startAngle
        if difference < 0 {
            difference += twoPi
        }
        return Int(60 * (difference / (CGFloat.pi / 6))) // π/6 = 30°
    }

    var startAngleDeg: CGFloat {
        startAngle * 180 / .pi
    }

//    var startAngleDeg: CGFloat = startAngle * 180 / .pi
    var endAngleDeg: CGFloat {
        endAngle * 180 / .pi
    }

    func timeFromAngle(_ angle: CGFloat) -> (hour: Int, minute: Int) {
        let twoPi = CGFloat.pi * 2
        var normalized = angle.truncatingRemainder(dividingBy: twoPi)
        if normalized < 0 { normalized += twoPi }
        // Convert angle to total minutes (12 hours = 720 minutes = 2π radians)
        let totalMinutes = normalized / twoPi * 720
        let hour = Int(totalMinutes) / 60
        let minute = Int(totalMinutes) % 60 // remainder (mod operator)
        return (hour, minute)
    }

    var formattedDuration: String {
        let hours = durationMinutes / 60
        let minutes = durationMinutes % 60

        if hours > 0 && minutes > 0 {
            return "\(hours) hour\(hours != 1 ? "s" : "") and \(minutes) minute\(minutes != 1 ? "s" : "") of sleep"
        } else if hours > 0 {
            return "\(hours) hour\(hours != 1 ? "s" : "") of sleep"
        } else {
            return "\(minutes) minute\(minutes != 1 ? "s" : "") of sleep"
        }
    }
    
    var body: some View {
        VStack {
            let startTime = timeFromAngle(startAngle)
            let endTime = timeFromAngle(endAngle)
            
            
//            Text("\(startAngle)")
            Text("\(startTime.hour):\(String(format: "%02d", startTime.minute)) - \(endTime.hour):\(String(format: "%02d", endTime.minute))")
                .font(.system(size: 38, weight: .bold, design: .default))
//            Text("\(startTime.hour)")
//            Text("\(startTime.minute)")
//            Text("\(startTime)")
//            Text("\(String(format: "%02d", startTime.minute))")
                .padding(20) // Adds 20 points
            ZStack {
                Circle() // Background circle
                    .stroke(Color(red: 123 / 255, green: 60 / 255, blue: 146 / 255).opacity(0.5), lineWidth: lineWidth * 3)
                    .frame(width: sliderDiameter, height: sliderDiameter)

                Canvas { context, size in // Clock's strips
                    let center = CGPoint(x: size.width / 2, y: size.height / 2)
                    let radius = sliderDiameter / 3 + 4
                    let tickLength: CGFloat = 8
                    let tickWidth: CGFloat = 2

                    for i in 0 ..< 12 { // 12 tick
                        let angle = CGFloat(i) * .pi / 6 // 30° per hour
                        let tickStart = CGPoint(
                            x: center.x + (radius - tickLength) * cos(angle),
                            y: center.y + (radius - tickLength) * sin(angle)
                        )
                        let tickEnd = CGPoint(
                            x: center.x + radius * cos(angle),
                            y: center.y + radius * sin(angle)
                        )

                        var path = Path()
                        path.move(to: tickStart)
                        path.addLine(to: tickEnd)
                        context.stroke(path, with: .color(Color.white.opacity(0.5)), lineWidth: tickWidth)
                    }
                }
                .frame(width: sliderDiameter, height: sliderDiameter)
                Canvas { context, size in // Inbetween Sleep
                    let center = CGPoint(x: size.width / 2, y: size.height / 2)
                    let radius = sliderDiameter / 2
                    var path = Path()
                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: Angle(radians: Double(startAngle)),
                        endAngle: Angle(radians: Double(endAngle)),
                        clockwise: false
                    )
                    context.stroke(path, with: .color(.purple), lineWidth: lineWidth * 2.5)
                }
                .frame(width: sliderDiameterAddWidth, height: sliderDiameterAddWidth)

                // Start handle
                handleView(angle: startAngle)
                    .foregroundColor(.cyan)
//                    .offset(x: (sliderDiameter / 2) * cos(startAngle), y: (sliderDiameter / 2) * sin(startAngle))
                    .offset(x: (sliderDiameter / 2) * cos(startAngle), y: (sliderDiameter / 2) * sin(startAngle))

                // End handle
                handleView(angle: endAngle)
                    .foregroundColor(.cyan)
                    .offset(x: (sliderDiameter / 2) * cos(endAngle), y: (sliderDiameter / 2) * sin(endAngle))
            }
            .frame(width: sliderDiameter, height: sliderDiameter)
            .gesture(DragGesture()
                .onChanged { value in
                    self.handleDrag(value: value.location) // the pressed white handle location
                }
                .onEnded { _ in
                    defaults.set(startAngle, forKey: "startAngle")
                    defaults.set(endAngle, forKey: "endAngle")
                    self.sliderLock = .none // change the handledrag to none when it stopped being pressed
                })
            .rotationEffect(.degrees(-90)) // Moves 0° to the top
            .padding(20) // Adds 20 padding surrounding the circle
            Text(formattedDuration)
                .font(.headline)
                .padding(.top, 20)
        }
    }

    // Function to create a knob handle based on angle
    private func handleView(angle _: CGFloat) -> some View {
        Circle()
            .fill(Color.white)
            .frame(width: knobDiameter, height: knobDiameter)
            .overlay(Circle().stroke(Color.black, lineWidth: 2))
    }

    // Helper function to calculate distance between two points
    private func distanceBetween(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let xDist = point2.x - point1.x
        let yDist = point2.y - point1.y
        return sqrt(xDist * xDist + yDist * yDist)
    }

    // Function to convert an angle to a point on the circle
    private func pointFromAngle(_ angle: CGFloat) -> CGPoint {
        let center = CGPoint(x: sliderDiameter / 2, y: sliderDiameter / 2)
        return CGPoint(x: center.x + (sliderDiameter / 2) * cos(angle), y: center.y + (sliderDiameter / 2) * sin(angle))
    }

    // Kalo ada coordinat
    // misal x 5
    // Function to convert a point into an angle
    private func angleFromPoint(_ point: CGPoint) -> CGFloat {
        let center = CGPoint(x: sliderDiameter / 2, y: sliderDiameter / 2)
        return atan2(point.y - center.y, point.x - center.x) // arctan (ydist/xdist), returns radians
    }

    // Function to handle dragging and updating the knob positions
    private func handleDrag(value: CGPoint) {
        let angle = angleFromPoint(value) // touch radian value of angle from center
        // Snapping the angle to hourly intervals (30 degrees)
        let snappedAngle = round(angle / (min5Snap * .pi / 180)) * min5Snap * .pi / 180
        // round the location to the closest 5 min snap point
        // Lock the nearest knob
        if sliderLock == .start { // first pressed rad angle
            startAngle = snappedAngle
        } else if sliderLock == .end { // handle bar last pressed rad angle
            endAngle = snappedAngle
        }
        // Determine which knob to lock, returns point from angle
        let startKnobPoint = pointFromAngle(startAngle)
        let endKnobPoint = pointFromAngle(endAngle)
        // which knob is being pressed based on the distance clicked
        let distanceToStart = distanceBetween(value, startKnobPoint)
        let distanceToEnd = distanceBetween(value, endKnobPoint)
        if distanceToStart < distanceToEnd {
            sliderLock = .start
        } else {
            sliderLock = .end
        }
    }
}

// TODO:
struct ClockSliderView_Previews: PreviewProvider {
    static var previews: some View {
        let startValue = CGFloat(UserDefaults.standard.double(forKey: "startAngle"))
        let endValue = CGFloat(UserDefaults.standard.double(forKey: "endAngle"))

        return ClockSlider(startAngle: startValue, endAngle: endValue)
    }
}
