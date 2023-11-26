//
//  Filtrs.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 26.11.2023.
//

import SwiftUI

struct Filtrs: View {
    
    @State var sliderValue: Double = 20000
    
    @State var ot: String = "0"
    @State var Do: String = "20000"
    
    @State var isOn: Bool = false
    var body: some View {
        ZStack () {
            VStack{
                VStack {

                    Text("Виды парковок")
                        .font(
                            Font.custom("SF Pro", size: 20)
                            .weight(.medium)
                        )
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width, height: 17, alignment: .topLeading)
                        .padding(.leading, 40)
                        .padding(.bottom, 20)
                    
                    // Назменые подземные
                    HStack {
                        Button(action: {}, label: {
                            HStack(alignment: .center, spacing: 10) {
                                Text("Наземные")
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
                                Text("Подземные")
                                    .tint(Color.white)
                            }
                            .padding(6)
                            .frame(width: 115, alignment: .center)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(.white, lineWidth: 1)
                            )
                        })
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .bottomLeading)
                    .padding(.leading, 40)

                    // Одноуровневые и многоуровневые кнопки
                    HStack {
                        Button(action: {}, label: {
                            HStack(alignment: .center, spacing: 10) {
                                Text("Одноуровневые")
                                    .tint(Color.white)
                            }
                            .padding(6)
                            .frame(width: 155, alignment: .center)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(.white, lineWidth: 1)
                            )
                        })
                        
                        Button(action: {}, label: {
                            HStack(alignment: .center, spacing: 10) {
                                Text("Многоуровневые")
                                    .tint(Color.white)
                            }
                            .padding(6)
                            .frame(width: 155, alignment: .center)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(.white, lineWidth: 1)
                            )
                        })
                        
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .bottomLeading)
                    .padding(.leading, 40)
                    
                    // Гостевые и стихийные
                    HStack {
                        Button(action: {}, label: {
                            HStack(alignment: .center, spacing: 10) {
                                Text("Гостевые")
                                    .tint(Color.white)
                            }
                            .padding(6)
                            .frame(width: 155, alignment: .center)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(.white, lineWidth: 1)
                            )
                        })
                        
                        Button(action: {}, label: {
                            HStack(alignment: .center, spacing: 10) {
                                Text("Стихийные")
                                    .tint(Color.white)
                            }
                            .padding(6)
                            .frame(width: 155, alignment: .center)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(.white, lineWidth: 1)
                            )
                        })
                        
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .bottomLeading)
                    .padding(.leading, 40)
                    
                    Text("Стоимость")
                        .font(
                            Font.custom("SF Pro", size: 20)
                            .weight(.medium)
                        )
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width, height: 17, alignment: .topLeading)
                        .padding(.top, 10)
                        .padding(.leading, 40)
                        .padding(.bottom, 20)
                    
                    Text("\(sliderValue, specifier: "%.0f")₽")
                        .foregroundColor(.white)
                        .padding(.leading, 25)
                        .frame(width: UIScreen.main.bounds.width , height: 17, alignment: .topLeading)

                    
                    Slider(
                        value: $sliderValue,
                        in: 0...20000
                    ) {
                        Text("Dan")
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 20)
                    .tint(.white)
                    
                    HStack () {
                        Text ("От")
                        TextField(ot, text: $ot)
                            .frame(width: 50, height: 25, alignment: .topLeading)
                            .cornerRadius(4)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .inset(by: 0.5)
                                    .stroke(.white, lineWidth: 1)
                            )
                        Text ("До")
                        TextField(Do, text: $Do)
                            .frame(width: 100, height: 25, alignment: .topLeading)
                            .cornerRadius(4)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .inset(by: 0.5)
                                    .stroke(.white, lineWidth: 1)
                            )
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.leading, 40)
                    .foregroundColor(.white)
                        
                    HStack () {
                        Toggle("Бесплатно", isOn: $isOn)
                        .toggleStyle(SwitchToggleStyle(tint: .white))
                    }
                    .padding(.horizontal, 20)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .foregroundColor(.white)
                    
                    Text("Выберите тип объекта")
                        .font(
                            Font.custom("SF Pro", size: 20)
                            .weight(.medium)
                        )
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width, height: 17, alignment: .topLeading)
                        .padding(.top, 10)
                        .padding(.leading, 40)
                        .padding(.bottom, 20)
                }
                VStack{
                    Button(action: {}, label: {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "figure.roll")
                            Text("Парковка для инвалидов")
                        }
                        .tint(Color.white)

                        .padding(6)
                        .frame(alignment: .center)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.5)
                            .stroke(.white, lineWidth: 1)
                        )
                    })
                    .padding(.leading, 20)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    Button(action: {}, label: {
                        HStack(alignment: .center, spacing: 10) {
                            Image("policemen")
                            Text("Охраняемые парковки")
                        }
                        .tint(Color.white)

                        .padding(6)
                        .frame(alignment: .center)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.5)
                            .stroke(.white, lineWidth: 1)
                        )
                    })
                    .padding(.leading, 20)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    Button(action: {}, label: {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "network")
                            Text("Общедоступные парковки")
                        }
                        .tint(Color.white)

                        .padding(6)
                        .frame(alignment: .center)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.5)
                            .stroke(.white, lineWidth: 1)
                        )
                    })
                    .padding(.leading, 20)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    Button(action: {}, label: {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "bus")
                            Text("Парковки для автобусов")
                        }
                        .tint(Color.white)

                        .padding(6)
                        .frame(alignment: .center)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.5)
                            .stroke(.white, lineWidth: 1)
                        )
                    })
                    .padding(.leading, 20)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    Button(action: {}, label: {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "camera")
                            Text("Видеонаблюдение")
                        }
                        .tint(Color.white)

                        .padding(6)
                        .frame(alignment: .center)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.5)
                            .stroke(.white, lineWidth: 1)
                        )
                    })
                    .padding(.leading, 20)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                }
                
            }
            

            
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .overlay(alignment: .topLeading, content: {
            Button(action: {}, label: {
                Text("Назад").foregroundStyle(.white)
            })
            .padding(.top, 70)
            .padding(.leading, 20)

        })
        .background(Color(red: 0.3, green: 0.21, blue: 0.87))
        .cornerRadius(18)
        
    }
}

#Preview {
    Filtrs()
}
