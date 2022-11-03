//
//  MapViewRepresentable.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//




import MapKit
import SwiftUI

struct MapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    var locationManager = LocationManager.shared
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    // MARK: - Protocol Functions
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        locationManager.mapView = mapView
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        switch homeViewModel.mapState {
        case .noInput, .tripCancelled:
            context.coordinator.clearMapView()
        case .tripAccepted:
            context.coordinator.clearMapView()
            context.coordinator.addAnnotationAndGeneratePolylineToPassenger(isRect: false)
        case .tripRequested:
            context.coordinator.addAnnotationAndGeneratePolylineToPassenger(isRect: false)
        case .tripInProgress:
            context.coordinator.clearMapView()
            context.coordinator.addDestinationAnnoAndPolyline()
        default:
            break
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        .init(parent: self)
    }
    
}

//MARK: - MapHelpers
extension MapViewRepresentable{
    func setCamera(){
        guard let userLocation = locationManager.userLocation else {return}
            let userCoordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let eyeCoordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.latitude)
            let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 400.0)
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
        mapView.cameraZoomRange = .init(minCenterCoordinateDistance: 100, maxCenterCoordinateDistance: 800)
        mapView.setCamera(mapCamera, animated: true)
    }
}

extension MapViewRepresentable {

    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        // MARK: - Properties
        
        let parent: MapViewRepresentable
        var userLocation: MKUserLocation?
        var didSetVisibleMapRectForTrip = false
        // MARK: - Lifecycle
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        // MARK: - MKMapViewDelegate
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocation = userLocation
            
            
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let over = MKPolylineRenderer(overlay: overlay)
            over.strokeColor = UIColor(named: "primaryBlue")
            over.lineWidth = 6
            return over
        }
        
        
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           
            if let destinationAnno = annotation as? MKPointAnnotation{
                let customAnnotationView = self.customAnnotationView(in: mapView, for: destinationAnno)
                return customAnnotationView
            }
            
            // want to show a custom image if the annotation is the user's location.
            guard !annotation.isKind(of: MKUserLocation.self) else {
                   let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
                annotationView.image = UIImage(named: "location.icon")?.imageResize(sizeChange: CGSize.init(width: 30, height: 35))
                   return annotationView
                   //return nil
               }
                        
            return nil
        }
        
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            guard let userLocation = userLocation else {return}
            mapView.cameraZoomRange = .init(minCenterCoordinateDistance: 100, maxCenterCoordinateDistance: 800)
            mapView.setUserTrackingMode(.followWithHeading, animated: true)
            mapView.camera.pitch = 45.0
            mapView.camera.heading = userLocation.heading?.trueHeading ?? 90
            
        }
        
        private func customAnnotationView(in mapView: MKMapView, for annotation: MKAnnotation, isCurrent: Bool = false) -> CustomLocationAnnotationView {
            let identifier = isCurrent ? "CurrentAnnotationAnno" : "DestinationAnnotationAnno"

            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomLocationAnnotationView {
                annotationView.annotation = annotation
                annotationView.isCurrent = isCurrent
                return annotationView
            } else {
                let customAnnotationView = CustomLocationAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                customAnnotationView.canShowCallout = true
                customAnnotationView.isCurrent = isCurrent
                return customAnnotationView
            }
        }
        
        //MARK: Helpers
                
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D, anno: MKAnnotation){
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
        }
        
        //for progress trip
        func addDestinationAnnoAndPolyline() {
            guard let trip = parent.homeViewModel.trip else { return }
            addAndSelectAnnotation(withCoordinate: trip.dropoffLocationCoordinates)
            configurePolyline(withDestinationCoordinate: trip.dropoffLocationCoordinates, withRect: false)
        }
        
        //for accept trip
        func addAnnotationAndGeneratePolylineToPassenger(isRect: Bool = true) {
            guard let trip = parent.homeViewModel.trip else { return }
            self.parent.mapView.removeAnnotations(parent.mapView.annotations)
            addAndSelectAnnotation(withCoordinate: trip.pickupLocationCoordiantes)
            self.configurePolyline(withDestinationCoordinate: trip.pickupLocationCoordiantes)
        }
        
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
        }
        
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D, withRect: Bool = false) {
            guard let userLocation = self.userLocation else { return }
            MapHelpers.getDestinationRoute(from: userLocation.coordinate, to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                if withRect{
                    let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                                   edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                    self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                }
            }
        }
        

        
        //MARK: - Add drivers annonatations
        func clearMapView() {
            didSetVisibleMapRectForTrip = false
            let annotations = parent.mapView.annotations
            removeAnnotationsAndOverlays(annotations)
        }
        
        func removeAnnotationsAndOverlays(_ annotations: [MKAnnotation]) {
            if !annotations.isEmpty{
                parent.mapView.removeAnnotations(annotations)
            }
                
            if !parent.mapView.overlays.isEmpty{
                parent.mapView.removeOverlays(parent.mapView.overlays)
            }
            
        }
    }
}







class CurrentAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D

    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    func updatePosition(withCoordinate coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
    }
}

class CustomLocationAnnotationView: MKAnnotationView {
    var isCurrent: Bool = false
    private let annotationFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = annotationFrame
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented!")
    }

    override func draw(_ rect: CGRect) {
        if isCurrent{
            UIColor.black.setFill()
            let outerPath = UIBezierPath(ovalIn: rect)
            outerPath.fill()
            UIColor.white.setFill()
            let centerPath = UIBezierPath(ovalIn: CGRect(x: 6, y: 6, width: 8, height: 8))
            centerPath.fill()
        }else{
            let rectangle = UIBezierPath(rect: rect)
            UIColor.black.setFill()
            rectangle.fill()
        }
    }
}
