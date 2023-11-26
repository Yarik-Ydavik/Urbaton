//
//  ParkingView.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 25.11.2023.
//

import SwiftUI
import MapKit

struct ParkingView: View {
    
    @EnvironmentObject private var vm : LocationManager

    @State private var userLocation: CLLocation?
    @State private var markerLocation: CLLocation?
    
    var body: some View {

        ZStack{
//            Map(
//                coordinateRegion: $vm.mapRegion,
//                annotationItems: vm.locations,
//                annotationContent: { Location in
//                    MapAnnotation(coordinate:CLLocationCoordinate2D(latitude: Location.location.latitude, longitude: Location.location.longitude)
//                    ) {
//                        Marker()
//                            .onTapGesture {
//                                vm.nextLocations(location: Location)
//                                // сохраняем координаты маркера
//                                markerLocation = CLLocation(latitude: Location.location.latitude, longitude: Location.location.longitude)
//                                getDirections()
//
//                            }
//                            .scaleEffect(Location.id == vm.mapLocation.id ? 1.5 : 1.0)
//                    }
//                }
//            )


            
            MapView()
                .environmentObject(vm)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                if vm.locations.count > 0 {
                    header
                        .padding(.horizontal)
                    Spacer()
                    
                    ZStack {
                        LocationPreviewView(location: vm.mapLocation)
                            .environmentObject(vm)
                            .shadow(color: Color.black.opacity(0.3), radius: 20)
                    }
                }
                
            }
        }
    }
    func getDirections() {
        // проверяем, что есть местоположение пользователя и маркер
        guard let userLocation = userLocation, let markerLocation = markerLocation else { return }
        
        // создаем запрос на построение маршрута
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: markerLocation.coordinate))
        request.transportType = .automobile
        
        // отправляем запрос на сервер
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
        guard let route = response?.routes.first else { return }
        // добавляем маршрут на карту
            self.vm.mapView.addOverlay(route.polyline)
    }
    }

}

#Preview {
    ParkingView()
        .environmentObject(LocationManager())
}

extension ParkingView {
    private var header : some View{
        HStack {
            VStack  {
                SearchView()
            }
            .frame(height: 200)
            .background(.clear)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 15)
            Spacer()
            Button {
                } label: {
                    Image(systemName: "plus")
                        .padding()
                        .font(.title2)
                        .bold()
                        .foregroundColor(.primary)
                }
                .background(.thickMaterial)
                .cornerRadius(15)
                .hidden()
        }
    }
}
