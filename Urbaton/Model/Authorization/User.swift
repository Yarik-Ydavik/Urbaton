//
//  User.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation

// MARK: - PostModel
struct User: Codable {
    let data: DataClass?
    let error: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let refreshToken: String?
    let refreshTokenExpire: Int?
    let accessToken: String?
    let accessTokenExpire: Int?
    
    func getTokensInfo() -> TokensInfo {
        return TokensInfo(refreshToken: refreshToken!,
                          refreshTokenExpire: Int64(refreshTokenExpire!),
                          accessToken: accessToken!,
                          accessTokenExpire: Int64(accessTokenExpire!))
    }
}


