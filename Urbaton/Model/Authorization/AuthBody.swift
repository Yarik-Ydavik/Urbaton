//
//  AuthBody.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation

struct AuthBody: Codable {
    let email: String
    let password: String
}
