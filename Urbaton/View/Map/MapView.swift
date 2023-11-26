//
//  MapView.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 25.11.2023.
//

import SwiftUI

import MapKit
import CoreLocation

struct MapViewAlgoritm: UIViewRepresentable {
    @EnvironmentObject var vm: LocationManager
    var mapView: MKMapView = MKMapView(frame: .zero)

    var routePoints: [CreateEventResponse]
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        
        for point in routePoints {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: point.location.latitude, longitude: point.location.longitude)
            annotation.title = point.name
            
            view.addAnnotation(annotation)
            
            
        }
        
        
        if vm.youtubeShorts {
            vm.findShortRoute(points: [
            CreateEventResponse(
                id: "0",
                name: "",
                cityName: "",
                location: locationRequest(latitude: vm.userLocation.latitude, longitude: vm.userLocation.longitude),
                description: "",
                date: "",
                maxCountPlaces: 0,
                currentCountPlaces: 0,
                images: [""])
            ], to: CreateEventResponse(
                id: "12",
                name: "Парковка",
                cityName: "Оренбург",
                location: locationRequest(latitude: 51.79225, longitude: 55.12378),
                description: "",
                date: "",
                maxCountPlaces: 10,
                currentCountPlaces: 5,
                images: ["Parking2"]
            ), on: view)
        }
        
        // Настроить область отображения карты, чтобы вместить все точки маршрута
        if !routePoints.isEmpty {
            let region = MKCoordinateRegion(center: vm.userLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
            view.setRegion(region, animated: true)
        } else {
            let region = MKCoordinateRegion(center: vm.userLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
            view.setRegion(region, animated: true)
        }
        
    }

    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineDashPattern = [2, 5];
            renderer.strokeColor = .purple
            renderer.lineWidth = 3
            return renderer
        }
    }
}

struct MapView: View {
    @EnvironmentObject private var vm: LocationManager
    
    @State var button: Bool = false
    
    var body: some View {
        
        ZStack{
//        routePoints: vm.parkingPlaces
            MapViewAlgoritm(routePoints: vm.locations )
                .environmentObject(vm)
                .ignoresSafeArea(.all)
                
//                .onAppear {
//                    vm.checkIFLocationServicesIsEnabled()
//                }
            
            
        }

    }
    
    
}

#Preview {
    MapView()
        .environmentObject(LocationManager())
}
