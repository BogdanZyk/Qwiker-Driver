//
//  CountDownTimerView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 07.11.2022.
//

import SwiftUI

struct CountDownTimerView : View {
    var timerType: TimerType
    @State var nowDate: Date = Date()
    @Binding var referenceDate: Date
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.nowDate = Date()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(countDownString(from: referenceDate))
                .font(.title2.weight(.medium))
            waitingText
        }
        .onAppear(perform: {
            _ = self.timer
    })
    }
    
    func countDownString(from date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar
            .dateComponents([.day, .hour, .minute, .second],
                            from: nowDate,
                            to: referenceDate)
        
        return getTimeToStrForTimeType(components)
    }
    
    func getTimeToStrForTimeType(_ components: DateComponents) ->
    String{
        let isDownTime: Bool = nowDate > referenceDate
        switch timerType {
        case .enRouteToPicup:
            return String(format: "\(isDownTime ? "Late " : "")%02d:%02d",
                          abs(components.minute ?? 00),
                          abs(components.second ?? 00))
        case .arrivalTrip:
            return String(format: "%02d:%02d",
                          abs(components.minute ?? 00),
                          abs(components.second ?? 00))
        case .inProgressTrip:
            return String(format: "%02d:%02d",
                          abs(components.minute ?? 00) ,
                          abs(components.second ?? 00))
        }
    }
    
    private var waitingText: some View{
        Group{
            if timerType == .arrivalTrip{
                Text("\(nowDate > referenceDate ? "Paid" : "Free") waiting")
                    .font(.poppinsRegular(size: 16))
                    .foregroundColor(.gray)
            }
        }
    }
}


struct CountDownTimerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CountDownTimerView(timerType: .inProgressTrip, referenceDate: .constant(Date()))
            CountDownTimerView(timerType: .arrivalTrip, referenceDate: .constant(Date() + 5))
            CountDownTimerView(timerType: .enRouteToPicup, referenceDate: .constant(Date() + 5))
        }
    }
}


enum TimerType{
    case enRouteToPicup, arrivalTrip, inProgressTrip
}
