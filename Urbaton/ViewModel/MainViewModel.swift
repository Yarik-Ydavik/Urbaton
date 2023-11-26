//
//  MainViewModel.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation
import SwiftUI
import CoreData

class MainViewModel: ObservableObject {
    
    @Published
    var showAuthContainer = true
    
    @Published
    var loginPending = false
    @Published
    var registerPending = false
    
    @Published
    var devsProgress: LoadingState = .notStarted
    @Published
    var developers: [Develop] = []
    
    @Published
    var alert: IdentifiableAlert?
    
    init() {
        let refreshToken = UserDefaultsWorker.shared.getRefreshToken()
        if !refreshToken.token.isEmpty && refreshToken.expireEt > Date().timestampMillis() {
            showAuthContainer = false
        }
//        UserDefaultsWorker.shared.loadTokens()
    }
    
    // Переменные для работы карты
    @Published var isAuthentificated: Bool = false
  

    func logout() {
        UserDefaultsWorker.shared.dropTokens()
        Requester.shared.dropTokens()
        withAnimation {
            showAuthContainer = true
        }
    }

    func login(login: String, password: String) {
        withAnimation {
            loginPending = true
        }
        print("login called")
        DispatchQueue.global(qos: .userInitiated).async {
            Requester.shared.login(authBody: AuthBody(number: login, pass: password, role: "user")) { [self] result in
                print("login response: \(result)")
                withAnimation {
                    loginPending = false
                }
                switch result {
                case .success(let user):
                    // do something with user
                    withAnimation {
                        self.showAuthContainer = false
                    }
                case .serverError(let err):
                    alert = IdentifiableAlert.buildForError(id: "login_server_err", message: Errors.messageFor(err: err.message))
                case .networkError(let err):
                    alert = IdentifiableAlert.networkError(err: err)
                case .authError(let err):
                    alert = IdentifiableAlert.buildForError(id: "login_err", message: Errors.messageFor(err: err.message))
                }
            }
        }
    }
    
    func register(login: String, password: String) {
        withAnimation {
            registerPending = true
        }
        print("register called")
        DispatchQueue.global(qos: .userInitiated).async {
            Requester.shared.register(authBody: AuthBody(number: login, pass: password, role: "user")) { [self] result in
                print("register response: \(result)")
                withAnimation {
                    registerPending = false
                }
                switch result {
                case .success(let user):
                    // do something with user
                    withAnimation {
                        self.showAuthContainer = false
                    }
                case .serverError(let err):
                    alert = IdentifiableAlert.buildForError(id: "login_server_err", message: Errors.messageFor(err: err.message))
                case .networkError(let err):
                    alert = IdentifiableAlert.networkError(err: err)
                case .authError(let err):
                    alert = IdentifiableAlert.buildForError(id: "login_err", message: Errors.messageFor(err: err.message))
                }
            }
        }
    }
    
    /// Получение списка пользователей
//        func getDevelopers() {
//            withAnimation {
//                devsProgress = .loading
//            }
//            print("вызов запроса получения пользователей")
//            DispatchQueue.global(qos: .userInitiated).async {
//                Requester.shared.getDevelopers() { [self] result in
//                    print("запрос получения пользователей: \(result)")
//                    withAnimation {
//                        registerPending = false
//                    }
//                    switch result {
//                    case .success(let devs):
//                        withAnimation {
//                            developers = devs.data ?? []
//                            devsProgress = .finished
//                        }
//                    case .serverError(let err):
//                        withAnimation {
//                            devsProgress = .error
//                        }
//                        alert = IdentifiableAlert.buildForError(id: "devs_server_err", message: Errors.messageFor(err: err.message))
//                    case .networkError(let err):
//                        withAnimation {
//                            devsProgress = .error
//                        }
//                        alert = IdentifiableAlert.networkError(err: err)
//                    case .authError(let err):
//                        withAnimation {
//                            self.showAuthContainer = true
//                        }
//                    }
//                }
//            }
//        }
}
