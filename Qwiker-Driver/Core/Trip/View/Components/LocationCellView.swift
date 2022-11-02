//
//  LocationCellView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//

import SwiftUI

struct LocationCellView: View {
    let isDestination: Bool
    let title: String
    var body: some View {
        HStack {
            Group{
               if isDestination{
                    Circle()
                        .fill(Color.primaryBlue)
               }else{
                   Rectangle()
                       .fill(Color.black.opacity(0.8))
               }
            }
            .frame(width: 10, height: 10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(isDestination ? "Where to:" : "Where from:")
                    .lineLimit(1)
                    .font(.poppinsMedium(size: 12))
                Text(title)
                    .lineLimit(1)
                    .font(.poppinsMedium(size: 20))
            }
        }
    }
}

struct LocationCellView_Previews: PreviewProvider {
    static var previews: some View {
        LocationCellView(isDestination: false, title: "Test address")
    }
}
