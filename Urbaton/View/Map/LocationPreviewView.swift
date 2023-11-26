//
//  LocationPreviewView.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 25.11.2023.
//

import SwiftUI
import MapKit

struct LocationPreviewView: View {
    @EnvironmentObject private var vm : LocationManager
    
    let location: CreateEventResponse
    var body: some View {
        VStack (alignment: .center){
            HStack(spacing: 16 ){
                imageLocation
                VStack (alignment: .leading, spacing: 4) {
                    Text("Парковка в Депо Москва ")
                      .font(Font.custom("SF Pro Display", size: 18).weight(.bold))
                      .foregroundColor(Color(red: 0.32, green: 0.30, blue: 0.86))
                    Text("ул. Лесная, дом 20")
                      .font(Font.custom("SF Pro Display", size: 13).weight(.light))
                      .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
                    HStack {
                        Image(systemName: "map")
                        Text("3 км")
                          .font(Font.custom("Montserrat", size: 13))
                          .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
                    }
                    HStack (alignment: .firstTextBaseline)  {
                        Text("Свободно:")
                              .font(Font.custom("Montserrat", size: 13))
                              .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60));
                        Text("10 мест")
                          .font(Font.custom("Montserrat", size: 13))
                          .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
                    }
                }
                
//                titleLocation
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                
                vm.youtubeShorts = true
                
            }, label: {
                HStack(spacing: 10) {
                  Text("Поехали")
                    .font(Font.custom("SF Pro Display", size: 18).weight(.bold))
                    .foregroundColor(.white)
                }
                .padding(EdgeInsets(top: 11, leading: 58, bottom: 11, trailing: 58))
                .frame(width: UIScreen.main.bounds.width / 1.5, height: 40)
                .background(
                  LinearGradient(gradient: Gradient(colors: [Color(red: 0.73, green: 0.17, blue: 0.89), Color(red: 0.28, green: 0.14, blue: 0.87)]), startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(8)
                .shadow(
                  color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 10.60, y: 4
                );
            })
            
            
            
//            VStack (spacing: 8){
//                learnMoreButton
//                nextButton
//            }
            
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .overlay(alignment: .topTrailing, content: {
                    Image(systemName: "xmark")
                        .padding()
                })
                
        )
        .cornerRadius(10)
        .padding()
        
    }
}

#Preview {
    ZStack {
        LocationPreviewView(location: LocationManager().locations.first!)
            .environmentObject(LocationManager())
        
    }
}

extension LocationPreviewView{
    private var imageLocation : some View{
        ZStack {
            if let Imagr = vm.locations.first?.images.first {
                Image(Imagr)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            } else {
                Image("image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var titleLocation : some View {
        VStack (alignment: .leading){
            
            
            Text(location.name)
                .font(.title3)
                .bold()
            Text(location.cityName)
                .font(.subheadline)
        }
    }
    
    private var learnMoreButton : some View{
        Button {
            
        } label: {
            Text ("Узнать больше")
                .font(.headline)
                .frame(width: 125,height: 35)
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var nextButton : some View{
        Button {
            vm.nextButtonClicked(location : location)
        } label: {
            Text ("Далее")
                .font(.headline)
                .frame(width: 125,height: 35)
        }
        .buttonStyle(.bordered)
    }
}
