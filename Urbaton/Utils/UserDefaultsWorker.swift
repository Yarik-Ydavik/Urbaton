//
//  UserDefaultsWorker.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation
import Combine
import CoreData

class UserDefaultsWorker {
    
    static let shared = UserDefaultsWorker()
    static let container = NSPersistentContainer (name: "UserTokens")
    static var tokensAuthorization: [UserTokens] = []

    private static let KEY_ACCESS_TOKEN = "access_token"
    private static let KEY_ACCESS_TOKEN_EXPIRE = "date_access"
    private static let KEY_REFRESH_TOKEN = "refresh_token"
    private static let KEY_REFRESH_TOKEN_EXPIRE = "date_refresh"
    

    
    func saveAuthTokens(tokens: TokensInfoData) {
        let defaults = UserDefaults.standard
        defaults.set(tokens.access_token, forKey: UserDefaultsWorker.KEY_ACCESS_TOKEN)
        defaults.set(tokens.date_access, forKey: UserDefaultsWorker.KEY_ACCESS_TOKEN_EXPIRE)
        defaults.set(tokens.refresh_token, forKey: UserDefaultsWorker.KEY_REFRESH_TOKEN)
        defaults.set(tokens.date_refresh, forKey: UserDefaultsWorker.KEY_REFRESH_TOKEN_EXPIRE)
    }
    
    func getAccessToken() -> TokenInfo {
        let defaults = UserDefaults.standard
        let token = defaults.object(forKey: UserDefaultsWorker.KEY_ACCESS_TOKEN) as? String ?? ""
        let expiresAt = defaults.object(forKey: UserDefaultsWorker.KEY_ACCESS_TOKEN_EXPIRE) as? Int64 ?? 0
        return TokenInfo(token: token, expireEt: expiresAt)
    }
    
    
    func getRefreshToken() -> TokenInfo {
        let defaults = UserDefaults.standard
        let token = defaults.object(forKey: UserDefaultsWorker.KEY_REFRESH_TOKEN) as? String ?? ""
        let expiresAt = defaults.object(forKey: UserDefaultsWorker.KEY_REFRESH_TOKEN_EXPIRE) as? Int64 ?? 0
        return TokenInfo(token: token, expireEt: expiresAt)
    }
    
    func haveAuthTokens() -> Bool {
        return !getAccessToken().token.isEmpty && !getRefreshToken().token.isEmpty
    }
    
    func dropTokens() {
        let defaults = UserDefaults.standard
        defaults.set("", forKey: UserDefaultsWorker.KEY_ACCESS_TOKEN)
        defaults.set(0 as Int64, forKey: UserDefaultsWorker.KEY_ACCESS_TOKEN_EXPIRE)
        defaults.set("", forKey: UserDefaultsWorker.KEY_REFRESH_TOKEN)
        defaults.set(0 as Int64, forKey: UserDefaultsWorker.KEY_REFRESH_TOKEN_EXPIRE)
    }
}
