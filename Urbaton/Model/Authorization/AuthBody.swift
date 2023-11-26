//
//  AuthBody.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation

struct AuthBody: Codable {
    let number: String
    let pass: String
    let role: String
}
