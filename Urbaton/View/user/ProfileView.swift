//
//  ProfileView.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 25.11.2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm : LocationManager
    @State var ElementsProfile = [
        ElementProfile(image: "Element1", name: "Текущий баланс", description: "0,00₽"),
        ElementProfile(image: "Element2", name: "Способы оплаты", description: "Выбрать"),
        ElementProfile(image: "Element3", name: "Транспортное средство", description: "В324КТ56 BMW"),
        ElementProfile(image: "Element4", name: "Мои бронирования", description: "Bсего: 1"),
        ElementProfile(image: "Element5", name: "История операций", description: "Просмотр"),
        ElementProfile(image: "Element6", name: "Мои отзывы", description: "Просмотр"),
        ElementProfile(image: "Element7", name: "Штрафы", description: "5 000 ₽"),

    ]
    
    
    var body: some View {
        ZStack (alignment: .top)  {
            
            VStack {
                NavigationView {
                   List {
                       ForEach(ElementsProfile) { item in
                           NavigationLink(destination: ProfileDetailView(item: item)) {
                               HStack {
                                   Image("\(item.image)")
                                       .resizable()
                                       .frame(width: 50, height: 50)
                                   VStack (alignment: .leading) {
                                       Text(item.name)
                                       Text(item.description)
                                           .foregroundColor(.gray)
                                   }
                                   
                                   Spacer()

                               }
                           }
                       }
                       .onMove(perform: move)
                   }
                   .navigationTitle("Элементы профиля")
                   .navigationBarItems(trailing: EditButton())
               }

                .padding(.top, 140)
                Button(action: {}, label: {
                    HStack(alignment: .center, spacing: 10) { Text("Выйти").foregroundStyle(.white) }
                    .padding(.horizontal, 146)
                    .padding(.vertical, 11)
                    .background(
                    LinearGradient(
                    stops: [
                    Gradient.Stop(color: Color(red: 0.33, green: 0.34, blue: 0.86), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.28, green: 0.14, blue: 0.87), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                    )
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.25), radius: 5.3, x: 0, y: 4)
                })
            }
            VStack {
                Text("Профиль")
                    .font(
                        Font.custom("SF Pro", size: 20)
                            .weight(.medium)
                    )
                    .foregroundColor(.white)
                    .padding()
                VStack (alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .foregroundStyle(.white)
                        Text("+7 (999)999 47-99")
                            .font(
                                Font.custom("SF Pro", size: 16)
                                    .weight(.medium)
                            )
                            .foregroundColor(.white)
                    }
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundStyle(.white)
                        Text("Добавьте Email для оповещений")
                            .font(
                                Font.custom("SF Pro", size: 16)
                                    .weight(.medium)
                            )
                            .foregroundColor(.white)
                    }
                }
                .frame(width: UIScreen.main.bounds.size.width)
            }
            .frame(width: UIScreen.main.bounds.size.width, height: 200)
            .overlay(alignment: .topTrailing, content: {
                Image(systemName: "pencil")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.white)
                    .padding(50)
                
            })
            .background(Color(red: 0.31, green: 0.23, blue: 0.87))
            .cornerRadius(12)
            .ignoresSafeArea(.all, edges: .top)
            
            
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        ElementsProfile.move(fromOffsets: source, toOffset: destination)
    }

}

struct ProfileDetailView: View {
    var item: ElementProfile

    var body: some View {
        VStack {
            Image("\(item.image)")
                .resizable()
                .frame(width: 100, height: 100)
            Text(item.name)
                .font(.title)
            Text(item.description)
                .foregroundColor(.gray)
        }
        .padding()
        .navigationBarTitle(item.name)
    }
}


#Preview {
    ProfileView()
        .environmentObject(LocationManager())
}

