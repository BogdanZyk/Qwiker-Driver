//
//  SlideToAction.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 07.11.2022.
//

import SwiftUI

struct MTSlideToOpen: View {
    
    // Public Property
    var sliderTopBottomPadding: CGFloat = 0
    var thumbnailTopBottomPadding: CGFloat = 0
    var thumbnailLeadingTrailingPadding: CGFloat = 0
    var textLabelLeadingPadding: CGFloat = 16
    var text: String = "MTSlideToOpen"
    var textFont: Font = .poppinsMedium(size: 18)
    var textColor = Color(.sRGB, red: 25.0/255, green: 155.0/255, blue: 215.0/255, opacity: 0.7)
    var thumbnailColor = Color(.sRGB, red: 25.0/255, green: 155.0/255, blue: 215.0/255, opacity: 1)
    var thumbnailBackgroundColor: Color = .clear
    var sliderBackgroundColor = Color(.sRGB, red: 0.1, green: 0.64, blue: 0.84, opacity: 0.1)
    var resetAnimation: Animation = .easeIn(duration: 0.3)
    var didReachEndAction: ((MTSlideToOpen) -> Void)?
    
    // Private Property
    @State private var draggableState: DraggableState = .ready
    
    private enum DraggableState {
        case ready
        case dragging(offsetX: CGFloat, maxX: CGFloat)
        case end(offsetX: CGFloat)
        
        var reachEnd: Bool {
            switch self {
            case .ready, .dragging(_, _):
                return false
            case .end(_):
                return true
            }
        }
        
        var isReady: Bool {
            switch self {
            case .dragging(_, _), .end(offsetX: _):
                return false
            case .ready:
                return true
            }
        }
        
        var offsetX: CGFloat {
              switch self {
              case .ready:
                return 0.0
              case .dragging(let offsetX,_):
                  return offsetX
              case .end(let offsetX):
                  return offsetX
              }
          }
        
        var textColorOpacity: Double {
            switch self {
            case .ready:
                return 1.0
            case.dragging(let offsetX, let maxX):
                return 1.0 - Double(offsetX / maxX)
            case .end(_):
                return 0.0
            }
        }
        
    }
    
    var body: some View {
        return GeometryReader { geometry in
            self.setupView(geometry: geometry)
        }
    }
    
    private func setupView(geometry: GeometryProxy) -> some View {
        let frame = geometry.frame(in: .global)
        let width = frame.size.width
        let height = frame.size.height
        let drag = DragGesture()
            .onChanged({ (drag) in
                let maxX = width - height - self.thumbnailLeadingTrailingPadding * 2 + self.thumbnailTopBottomPadding * 2
                let currentX = drag.translation.width
                if currentX >= maxX {
                    self.draggableState = .end(offsetX: maxX)
                    self.didReachEndAction?(self)
                } else if currentX <= 0 {
                    self.draggableState = .dragging(offsetX: 0, maxX: maxX)
                } else {
                    self.draggableState = .dragging(offsetX: currentX, maxX: maxX)
                }
            })
            .onEnded(onDragEnded)
        let sliderCornerRadius = (height - sliderTopBottomPadding * 2) / 2
        return HStack {
            ZStack(alignment: .leading, content: {
                HStack {
                    Spacer()
                    Text(self.text)
                        .font(textFont)
                        .frame(maxWidth: .infinity)
                        .padding([.leading], textLabelLeadingPadding)
                        .foregroundColor(self.textColor)
                        .opacity(self.draggableState.textColorOpacity)
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .padding(.trailing)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(self.sliderBackgroundColor)
                .cornerRadius(sliderCornerRadius)
                .padding([.top, .bottom], self.sliderTopBottomPadding)
                
                Image(systemName: "arrow.right")
                    .imageScale(.large)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1.0, contentMode: .fit)
                    .background(self.thumbnailColor)
                    .clipShape(Circle())
                    .padding([.top, .bottom], self.thumbnailTopBottomPadding)
                    .padding([.leading, .trailing], self.thumbnailLeadingTrailingPadding)
                    .cornerRadius(sliderCornerRadius)
                    .offset(x: self.self.draggableState.offsetX)
                    .animation(self.draggableState.isReady ? self.resetAnimation : nil, value: UUID())
                    .gesture(self.draggableState.reachEnd ? nil : drag)
            })
        }
        .background(Color.white)
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        switch draggableState {
        case .end(_), .dragging(_, _):
            draggableState = .ready
            break
        case .ready:
            break
        }
    }
    
    // MARK: Public Function
    
    func resetState(_ animated: Bool = true) {
        self.draggableState = .ready
    }
}

struct SlideToAction_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            MTSlideToOpen(thumbnailTopBottomPadding: -2,
                                  thumbnailLeadingTrailingPadding: -2,
                                  text: "Slide to unlock",
                                  textColor: .white,
                                  thumbnailColor: Color.primaryBlue,
                          sliderBackgroundColor: Color.secondaryGrey,
                                  didReachEndAction: { view in
                        print("reach end!!")
                    })
            .frame(width: 320, height: 56)
            .cornerRadius(28)
        }
    }
}
