//
//  AcceptTripView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

//import SwiftUI
//import MapKit
//
//struct AcceptTripView: View {
//    let trip: Trip
//    @EnvironmentObject var viewModel: HomeViewModel
//    @State private var region: MKCoordinateRegion
//    let annotationItem: AppLocation
//
//    init(trip: Trip) {
//        self.trip = trip
//
//        self.region = MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: trip.pickupLocationCoordiantes.latitude,
//                                           longitude: trip.pickupLocationCoordiantes.longitude),
//            span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
//        )
//
//        self.annotationItem = AppLocation(title: trip.pickupLocationName, coordinate: trip.pickupLocationCoordiantes)
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            Capsule()
//                .foregroundColor(Color(.systemGray5))
//                .frame(width: 48, height: 6)
//                .padding(.top, 8)
//
//            VStack {
//                HStack {
//                    Text("Would you like to pickup this passenger?")
//                        .font(.headline)
//                        .fontWeight(.semibold)
//                        .lineLimit(2)
//                        .multilineTextAlignment(.leading)
//                        .frame(height: 44)
//
//                    Spacer()
//
//                    //EstimatedTimeArrivalView(time: "10")
//                }
//                .padding()
//
//                Divider()
//
//                HStack {
////                    UserImageAndDetailsView(imageUrl: trip.passengerImageUrl, username: trip.passengerFirstNameUppercased)
//
//                    Spacer()
//
//                    VStack(spacing: 4) {
//                        Text("Earnings")
//                            .font(.system(size: 15, weight: .semibold))
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(.gray)
//
////                        Text(trip.tripCost.toCurrency())
////                            .font(.system(size: 24, weight: .semibold))
//                    }
//                }
//                .padding()
//
//                Divider()
//            }
//
//            VStack(alignment: .leading) {
//                HStack {
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text(trip.pickupLocationName)
//                            .font(.headline)
//
//                        Text(trip.pickupLocationAddress)
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//
//                    Spacer()
//
//                    VStack(spacing: 6) {
//                        Text("5.2")
//                            .font(.headline)
//                            .fontWeight(.semibold)
//
//                        Text("mi")
//                            .foregroundColor(.gray)
//                            .font(.subheadline)
//                    }
//
//                }
//                .padding(.horizontal)
//
//                Map(coordinateRegion: $region, annotationItems: [annotationItem]) { item in
//                    MapMarker(coordinate: item.coordinate)
//                }
//                .frame(height: 220)
//                .cornerRadius(10)
//                .padding(.horizontal)
//                .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 0)
//            }
//            .padding(.vertical)
//            .frame(maxWidth: .infinity, alignment: .leading)
//
//            Divider()
//                .padding(.horizontal, 8)
//
//            Spacer()
//
//            actionButtons
//
//            Spacer()
//        }
//        .ignoresSafeArea()
//        .background(Color.primaryBg)
//        .frame(height: 640)
//        .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 12))
//        .shadow(color: .black, radius: 10, x: 0, y: 0)
//    }
//}
//
//
//
//struct AcceptTripView_Previews: PreviewProvider {
//    static var previews: some View {
//        AcceptTripView(trip: dev.mockTrip)
//            .environmentObject(dev.homeViewModel)
//    }
//}
//
//
//extension AcceptTripView {
//    var actionButtons: some View {
//        HStack {
//            Button {
//                viewModel.rejectTrip()
//            } label: {
//                Text("Reject")
//                    .font(.headline)
//                    .fontWeight(.bold)
//                    .padding()
//                    .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 56)
//                    .background(.red)
//                    .cornerRadius(10)
//                    .foregroundColor(.white)
//            }
//
//            Spacer()
//
//            Button {
//                viewModel.acceptTrip()
//            } label: {
//                Text("Accept")
//                    .font(.headline)
//                    .fontWeight(.bold)
//                    .padding()
//                    .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 56)
//                    .background(.blue)
//                    .cornerRadius(10)
//                    .foregroundColor(.white)
//
//            }
//
//        }
//        .padding(.horizontal)
//    }
//}
