//
//  ListParkView.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 25.11.2023.
//

import SwiftUI

struct ListParkView: View {
    @EnvironmentObject private var vm : LocationManager
    
    var body: some View {
        VStack {
            ParkingFiltrView()
                .environmentObject(vm)
            NavigationStack {
                
                List{
                    ForEach(Array(vm.locations.enumerated()), id: \.element) { index, location in
                        NavigationLink {
    //                        UserRecordView(location: location)
    //                            .environmentObject(vm)
                        } label: {
                            HStack{
                                if let Imagr = vm.locations.first?.images.first {
                                    Image(Imagr)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 45, height: 45)
                                        .cornerRadius(10)
                                } else {
                                    Image("image")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 45, height: 45)
                                        .cornerRadius(10)
                                }
                                VStack (alignment: .leading) {
                                    Text(location.name)
                                        .font(.headline)
                                    Text(
                                        vm.eventAddress[location.id]?.name  ??  location.cityName
                                    )
                                        .lineLimit(1)
                                        .font(.subheadline)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                VStack {
                                    Text ("Мест")
                                    Text ((location.maxCountPlaces - location.currentCountPlaces).description)
                                }
                                .onAppear(perform: {
                                    if !location.images.isEmpty{
                                        if !vm.eventImages.isEmpty {
                                            vm.downloadImage = true
                                        } else { vm.downloadImage = false }
                                        if !vm.downloadImage {
    //                                        vm.loadImage(from: location.images.first!, eventId: location.id) { image in
    //                                            print(image)
    //                                        }
                                        }
                                        vm.searchAddres(location: location)
                                    }
                                    
                                })
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }}

#Preview {
    ListParkView()
        .environmentObject(LocationManager())
}



