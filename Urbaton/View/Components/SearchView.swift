//
//  SearchView.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 26.11.2023.
//

import SwiftUI
import CoreLocation
import MapKit
import AVKit

struct SearchView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    @State var navigationTag: String?
    @State var showList = false
    
    @State private var showSheet = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            
            ScrollView  {
                TextFieldEvent(
                    icon: "magnifyingglass",
                    hint: "Найти локацию",
                    binding: $locationManager.searchText,
                    bindingButton: $showList
                )
                
                
                if showList == true, let places = locationManager.fetchedPlaces, !places.isEmpty {
                    ScrollView {
                        ForEach (places, id: \.self) { place in
                            Button(action: {
                                if let coordinate = place.location?.coordinate{
                                    locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                    locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                    locationManager.addDraggablePin(coordinate: coordinate)
                                    locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                }
                                navigationTag = "MAPVIEW"
                            }, label: {
                                HStack(spacing: 15, content: {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.gray)
                                    
                                    VStack(alignment: .leading, spacing: 6, content: {
                                        Text(place.name ?? "")
                                            .font(.title3.bold())
                                            .foregroundStyle(Color.primary )
                                        
                                        Text(place.locality ?? "")
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                    })
                                })
                            })
                            .frame(width: UIScreen.main.bounds.size.width - 150, alignment: .leading)
                        }
                    }

                }else {
//                    Button(action: {
//
//                        locationManager.mapView.region = .init(center: locationManager.userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
//                        locationManager.addDraggablePin(coordinate: locationManager.userLocation)
//                        locationManager.updatePlacemark(location: .init(latitude: locationManager.userLocation.latitude, longitude: locationManager.userLocation.longitude))
//                        navigationTag = "MAPVIEW"
//                    }, label: {
//                        Label(
//                            title: { Text("Использовать текущее местоположение").font(.callout) },
//                            icon: { Image(systemName: "location.north.circle.fill") }
//                        )
//                        .foregroundStyle(.green)
//                    })
//                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .background{
                NavigationLink(tag: "MAPVIEW", selection: $navigationTag) {
                    MapViewSelection(showLocations: $showList)
                        .environmentObject(locationManager)
                        .toolbar(.hidden)
                } label: {}
                    .labelsHidden()
            }
        }
    }
}


extension SearchView {
    private func TextFieldEvent (
        icon: String,
        hint: String,
        binding: Binding<String>,
        bindingButton: Binding<Bool>
    ) -> some View {
        HStack(spacing: 10, content: {
            Image(systemName: "\(icon)")
                .foregroundStyle(.gray)
            TextField("\(hint)", text: binding)
                .onTapGesture {
                    bindingButton.wrappedValue = hint == "Найти локацию" ? true : false
                }

            
        })
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.vertical, 5)

    }
    
}

#Preview {
    SearchView()
        .environmentObject(LocationManager())
}

struct MapViewSelection: View {
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) var dismiss
    
    @Binding var showLocations: Bool
    var body: some View {
        ZStack {
            MapViewHelper()
                .environmentObject(locationManager)
                .ignoresSafeArea()
            
            Button (action: {
                dismiss()
            }, label: {
                Image (systemName: "chevron.left")
                    .font(.title2.bold())
                    .foregroundStyle(Color.primary)
            })
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            if let place = locationManager.pickedPlaceMark {
                VStack (spacing: 15, content: {
                    Text("Подтвердите локацию")
                        .font(.title2.bold())
                    
                    HStack(spacing: 15, content: {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.gray)
                        
                        VStack(alignment: .leading, spacing: 6, content: {
                            Text(place.name ?? "")
                                .font(.title3.bold())
                            
                            Text(place.locality ?? "")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        })
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    
                    Button(action: {
                        locationManager.searchText = place.name ?? ""
                        showLocations = false
                        
                        // здесь отправка локации
                        locationManager.latitude = (place.location?.coordinate.latitude)!
                        locationManager.longtitude = (place.location?.coordinate.longitude)!
                        dismiss()
                        
                        
                    }, label: {
                        Text("Подтвердить локацию")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background{
                                RoundedRectangle (cornerRadius: 10, style: .continuous)
                                    .fill(Color.green)
                            }
                            .overlay(alignment: .trailing) {
                                Image(systemName: "arrow.right")
                                    .font(.title3.bold())
                                    .padding(.trailing)
                            }
                            .foregroundStyle(Color.white)
                    })
                })
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .ignoresSafeArea()
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .onDisappear(perform: {
            locationManager.pickedLocation = nil
            locationManager.pickedPlaceMark = nil
            
            locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
        })
    }
    
}

struct MapViewHelper: UIViewRepresentable{
    @EnvironmentObject var locationManager: LocationManager
    
    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
}
