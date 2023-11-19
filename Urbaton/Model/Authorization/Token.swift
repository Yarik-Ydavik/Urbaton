//
//  Token.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation

// Ответ на запрос обновления токенов
struct TokensInfo: Codable {
    let refreshToken: String
    let refreshTokenExpire: Int64
    let accessToken: String
    let accessTokenExpire: Int64
    
}

// Тело запроса обновления
struct TokenInfo {
    let token: String
    let expireEt: Int64
}
