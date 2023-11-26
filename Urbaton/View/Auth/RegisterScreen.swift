//
//  RegisterScreen.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import SwiftUI

struct RegisterScreen: View {
    @EnvironmentObject
    var mainVm: MainViewModel
    
    @State
    var login = ""
    @State
    var password = ""
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    Image(systemName: "car")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240, height: 135)
                        .padding(.top, 60)
                    VStack(spacing: 0) {
                        
                        Text("Регистрация")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        HStack {
                            Text("Номер телефона")
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.top, 12)
                        
                        TextField("", text: $login.animation())
                            .foregroundColor(.black)
                            .disabled(mainVm.registerPending)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 1)
                                .opacity(0.5))
                            .padding(.top, 4)
                        
                        
                        HStack {
                            Text("Пароль")
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.top, 12)
                        SecureField("", text: $password)
                            .foregroundColor(.black)
                            .font(Font.custom("montserrat-medium", size: 17))
                            .disabled(mainVm.registerPending)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 1)
                                .opacity(0.5))
                            .padding(.top, 4)
                        
                        if mainVm.loginPending {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                .scaleEffect(1.4)
                                .padding(.top, 26)
                        } else {
                            Button {
                                hideKeyboard()
                                if login.isEmpty {
                                    mainVm.alert = IdentifiableAlert.build(id: "empty_login",
                                                                           title: "Недопустимый номер телефона",
                                                                           message: "Номер телефона не должен быть пустым")
                                    return
                                }
                                if password.count < 2 {
                                    mainVm.alert = IdentifiableAlert.build(id: "empty_login",
                                                                           title: "Недопустимый пароль",
                                                                           message: "Пароль не должен быть меньше 2 символов")
                                    return
                                }
                                mainVm.register(login: login, password: password)
                            } label: {
                                Text("Зарегестрироваться")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.black)
                            }
                            .disabled(mainVm.registerPending)
                            .cornerRadius(10)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 24)
                        }
                        
                        HStack {
                            Button {
                                hideKeyboard()
                                // Логика авторизации через Telegram
    //                            mainVm.loginWithTelegram(login: login, password: password)
                            } label: {
                                HStack {
                                    Image(systemName: "paperplane.fill")
                                        .tint(Color.white)
                                    Text("Telegram")
                                        .foregroundColor(Color.white)
                                        .fontWeight(.light)
                                        .frame(maxWidth: .infinity)
                                }
                                .padding()
                                .background(Color.blue)

                                
                            }
                            .cornerRadius(10)
                            
                            Button {
                                hideKeyboard()
                                // Логика авторизации через Google
    //                            mainVm.loginWithTelegram(login: login, password: password)
                            } label: {
                                HStack {
                                    Image(systemName: "g.circle.fill")
                                        .tint(Color.white)
                                    Text("Google")
                                        .foregroundColor(Color.white)
                                        .fontWeight(.light)
                                        .frame(maxWidth: .infinity)
                                }
                                .padding()
                                .background(Color.red)
                                
                            }
                            .cornerRadius(10)
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .padding(.horizontal, 40)
                    .padding(.top, 80)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .alert(item: $mainVm.alert) { alert in
            alert.alert()
        }
    }
}

#Preview {
    RegisterScreen().environmentObject(MainViewModel())
}
