//
//  Token.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation

// Ответ на запрос обновления токенов
// MARK: - TokensInfo
struct TokensInfo: Codable {
    let data: TokensInfoData?
    let error: String?
}

// MARK: - TokensInfoData
struct TokensInfoData: Codable {
    let access_token: String?
    let refresh_token: String?
    let date_access: Int64?
    let date_refresh: Int64?
}

// Тело запроса обновления
struct TokenInfo {
    let token: String
    let expireEt: Int64
}
