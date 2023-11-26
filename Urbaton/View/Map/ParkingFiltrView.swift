//
//  ParkingFiltrView.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 26.11.2023.
//

import SwiftUI
import MapKit

struct ParkingFiltrView: View {
    @EnvironmentObject private var vm : LocationManager
    
    @State var showActionSheet: Bool = false
    @State var showSheet: Bool = false
    @State var timeParking = "1 час"

    var body: some View {
        VStack (alignment: .center){
            HStack(alignment: .lastTextBaseline, content: {
                Spacer()
                Button(action: { showActionSheet.toggle() }, label: {
                    Text("\(timeParking) парковки")
                        .font(.subheadline)
                        .tint(Color.white)
                })
                .actionSheet(isPresented: $showActionSheet, content: getTimeActionSheet)

                Button(action: { showSheet.toggle() }, label: {
                    Text("Фильтры")
                        .tint(Color.white)
                })
                .padding(.horizontal)
                .sheet(isPresented: $showSheet, content: {
                    Filtrs()
                })
            })
            HStack {
                Button(action: {}, label: {
                    
                    HStack(alignment: .center, spacing: 10) {
                        Text("Суточная")
                            .tint(Color.white)
                    }
                    .padding(6)
                    .frame(width: 95, alignment: .center)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.5)
                        .stroke(.white, lineWidth: 1)
                    )
                })
                
                Button(action: {}, label: {
                    HStack(alignment: .center, spacing: 10) {
                        Text("Месячная")
                            .tint(Color.white)
                    }
                    .padding(6)
                    .frame(width: 95, alignment: .center)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.5)
                        .stroke(.white, lineWidth: 1)
                    )
                })
                
                Button(action: {}, label: {
                    HStack(alignment: .center, spacing: 10) {
                        Text("Все")
                            .tint(Color.white)
                    }
                    .padding(6)
                    .frame(width: 95, alignment: .center)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.5)
                        .stroke(.white, lineWidth: 1)
                    )
                })
            }
        }
        .padding(20)
        .background(
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 340, height: 80)
            .background(Color(red: 0.31, green: 0.23, blue: 0.87))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.25), radius: 2.6, x: 0, y: 4)

                
        )
        .padding()
    }

    func getTimeActionSheet() -> ActionSheet {
        let button1: ActionSheet.Button = .default(Text("1 час")) { timeParking = "1 час" }
        let button2: ActionSheet.Button = .default(Text("2 чаca")) { timeParking = "2 часa" }
        let button3: ActionSheet.Button = .default(Text("4 чаca")) { timeParking = "4 часa" }
        let button4: ActionSheet.Button = .default(Text("Собственное")) { timeParking = "24 часa" }
        let button5: ActionSheet.Button = .cancel(Text("Отмена"))
            return ActionSheet(title: Text ("Продолжительность парковки"), buttons: [button1, button2, button3, button4, button5])
    }

}

#Preview {
    ZStack {
        ParkingFiltrView()
            .environmentObject(LocationManager())
        
    }
}
