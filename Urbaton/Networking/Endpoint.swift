//
//  Endpoint.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation

enum Endpoint {
    
    // ссылка
    static let baseURL: String  = "http://192.168.0.200:5000/"

    case register
    case login
    case refreshTokens
    case getDevelopers
    
    func path() -> String {
        switch self {
        case .register:
            return "register"
        case .login:
            return "login"
        case .refreshTokens:
            return "refresh_tokens"
        case .getDevelopers:
            return "api/users"
        }
    }
    
    var absoluteURL: URL {
        URL(string: Endpoint.baseURL + self.path())!
    }
}
