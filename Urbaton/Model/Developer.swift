//
//  Developer.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation

// MARK: - Developer
struct Developer: Codable {
    let data: [Develop]?
    let error: String?
}

// MARK: - Develop
struct Develop: Codable {
    let id, pass, email: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case pass = "Pass"
        case email = "Email"
    }
}
