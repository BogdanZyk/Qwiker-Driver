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
        HStack(spacing: 20) {
            Circle()
                .stroke(lineWidth: 3)
                .fill(isDestination ? Color.primaryBlue : Color.secondaryGrey)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(isDestination ? "Where to:" : "Where from:")
                    .foregroundColor(.gray)
                    .font(.poppinsMedium(size: 12))
                Text(title)
                    .lineLimit(1)
                    .font(.headline.weight(.medium))
            }
        }
    }
}

struct LocationCellView_Previews: PreviewProvider {
    static var previews: some View {
        LocationCellView(isDestination: false, title: "Test address")
    }
}
