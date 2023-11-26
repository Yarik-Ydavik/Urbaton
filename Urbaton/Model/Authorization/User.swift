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
    let access_token: String?
    let refresh_token: String?
    let date_access: Int?
    let date_refresh: Int?
    
    func getTokensInfo() -> TokensInfo {
        return TokensInfo(
            data: TokensInfoData(
                access_token: access_token!,
                refresh_token: refresh_token!,
                date_access: Int64(date_access!),
                date_refresh: Int64(date_refresh!)
                ),
            error: ""
        )
        
    }
}


