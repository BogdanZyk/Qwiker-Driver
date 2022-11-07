//
//  CountDownTimerView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 07.11.2022.
//

import SwiftUI

struct CountDownTimerView : View {
    
    @State var nowDate: Date = Date()
    @Binding var referenceDate: Date
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.nowDate = Date()
        }
    }
    
    var body: some View {
        Text(countDownString(from: referenceDate))
            .font(.title2.weight(.medium))
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
        let isDownTime: Bool = nowDate > referenceDate
        return String(format: "\(isDownTime ? "Late" : "")%02d:%02d",
                      components.minute ?? 00,
                      abs(components.second ?? 00))
    }
}


struct CountDownTimerView_Previews: PreviewProvider {
    static var previews: some View {
        CountDownTimerView(referenceDate: .constant(Date() + 5))
    }
}
