//
//  LocationRowsViewComponent.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//

import SwiftUI

struct LocationRowsViewComponent: View {
    let pickupLocationAddress: String
    let dropoffLocationName: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            LocationCellView(isDestination: false, title: pickupLocationAddress)
            Divider()
            LocationCellView(isDestination: true, title: dropoffLocationName)
        }
        .hLeading()
    }
}

struct LocationRowsViewComponent_Previews: PreviewProvider {
    static var previews: some View {
        LocationRowsViewComponent(pickupLocationAddress: "Test", dropoffLocationName: "test 2")
    }
}


