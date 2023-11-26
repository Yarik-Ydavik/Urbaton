//
//  RowLocationsView.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 25.11.2023.
//

import SwiftUI

struct RowLocationsView: View {
    @EnvironmentObject private var vm : LocationManager

    var body: some View {
        List{
            ForEach(vm.locations) { location in
                Button {
                    vm.nextLocations(location: location)
                } label: {
                    RowLocation(location: location)

                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
        }.listStyle(.plain)
    }
}

#Preview {
    RowLocationsView()
        .environmentObject(LocationManager())

}

extension RowLocationsView {
    private func RowLocation (location : CreateEventResponse) -> some View {
        return HStack{

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
                Text("Парковка")
                    .font(.headline)
                Text(vm.userCity)
                    .lineLimit(1)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
