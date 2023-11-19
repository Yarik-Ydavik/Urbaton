//
//  AuthError.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation

struct ErrorResponse: Codable {
    let code: Int
    let message: String
    
    func isAuth() -> Bool {
        return Errors.isAuthError(err: message)
    }
}
