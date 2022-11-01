//
//  CustomProgressView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import SwiftUI

struct CustomProgressView: View {
    var bgColor: Color = Color.gray.opacity(0.5)
    var progressColor: Color = .primaryBlue
    var height: CGFloat = 4
    var progress: Double
    var total: Double
    var body: some View {
             ProgressView("", value: progress, total: total)
                .progressViewStyle(LineProgressStyle(progressBg: progressColor , bg: bgColor, cornerRadius: 5, height: height))
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView(progress: 10, total: 100)
            .padding()
    }
}



struct LineProgressStyle<Background: ShapeStyle>: ProgressViewStyle {
    var progressBg: Background
    var bg: Background
    var cornerRadius: CGFloat = 10
    var height: CGFloat = 20
    var animation: Animation = .easeInOut

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return ZStack(alignment: .topLeading) {
            GeometryReader { geo in
                Rectangle()
                    .fill(bg)
                Rectangle()
                    .fill(progressBg)
                    .frame(maxWidth: geo.size.width * CGFloat(fractionCompleted))
                    .animation(animation, value: fractionCompleted)
            }
        }
        .frame(height: height)
        .cornerRadius(cornerRadius)
    }
}
