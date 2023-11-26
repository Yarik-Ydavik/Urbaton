//
//  Home.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 20.11.2023.
//

//import SwiftUI
//
//struct Home: View {
//    @EnvironmentObject
//    var mainVm: MainViewModel
//    
//    var body: some View {
//        VStack(spacing: 0){
//            switch mainVm.devsProgress {
//                
//            case .finished:
//                ZStack {
//                    VStack(spacing: 0) {
//                        ScrollView {
//                            LazyVStack(spacing: 16) {
//                                ForEach(mainVm.developers, id: \.id) { dev in
//                                    VStack {
//                                        Text(dev.email ?? "Нет email")
//                                        Text(dev.pass ?? "Нет пароля")
//                                    }
//                                }
//                            }
//                            .padding(.vertical, 14)
//                        }
//                    }
//                    VStack {
//                        Spacer()
//                        Button {
////                            mainVm.getDevelopers()
//                        } label: {
//                            Image(systemName: "arrow.clockwise")
//                                .renderingMode(.template)
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(Color.white)
//                                .frame(width: 30, height: 30)
//                                .padding(10)
//                                .background(Circle().fill(Color.black))
//                                .padding(.bottom, 20)
//                        }
//                        .opacity(0.9)
//                    }
//                }
//            case .notStarted, .loading:
//                Spacer()
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
//                    .scaleEffect(1.6)
//                    .padding(.top, 26)
//                Spacer()
//            case .error:
//                Spacer()
//                Text("Ошибка возникла при загрузке данных")
//                    .padding(.horizontal, 24)
//                Button {
////                    mainVm.getDevelopers()
//                } label: {
//                    Text("Повторить")
//                        .foregroundColor(Color.white)
//                        .fontWeight(.bold)
//                        .padding(.vertical, 12)
//                        .padding(.horizontal, 50)
//                        .background(Color.black)
//                }
//                .cornerRadius(10)
//                .padding(.top, 16)
//                .padding(.horizontal, 24)
//                Spacer()
//            }
//        }
//        .navigationBarTitle("Пользователи", displayMode: .inline)
//        .toolbar {
//            Button("Выйти") {
//                mainVm.logout()
//            }
//        }
//        .background(Color.white.ignoresSafeArea())
//        .alert(item: $mainVm.alert) { alert in
//            alert.alert()
//        }
//        .onAppear {
//            if mainVm.developers.isEmpty {
////                mainVm.getDevelopers()
//            }
//        }
//    }
//}
//
//#Preview {
//    Home().environmentObject(MainViewModel())
//}
