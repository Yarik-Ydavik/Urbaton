//
//  AuthorizationService.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation

class Requester {
    
    static let shared = Requester()
    static private let ACCESS_TOKEN_LIFE_THRESHOLD_SECONDS: Int64 = 10
    
    private var accessToken = UserDefaultsWorker.shared.getAccessToken()
    private var refreshToken = UserDefaultsWorker.shared.getRefreshToken()
    
    private init() {}
    
    private func onTokensRefreshed(tokens: TokensInfo) {
        UserDefaultsWorker.shared.saveAuthTokens(tokens: tokens.data!)
        accessToken = TokenInfo(token: tokens.data!.access_token!, expireEt: tokens.data!.date_access!)
        refreshToken = TokenInfo(token: tokens.data!.refresh_token!, expireEt: tokens.data!.date_refresh!)
    }
    
    func dropTokens() {
        accessToken = TokenInfo(token: "", expireEt: 0)
        refreshToken = TokenInfo(token: "", expireEt: 0)
    }
    
    private func formRequest(url: URL,
                     data: Data = Data(),
                     method: String = "POST",
                     contentType: String = "application/json",
                     refreshTokens: Bool = false,
                     ignoreJwtAuth: Bool = false) -> URLRequest {
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = method
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        if refreshTokens {
            request.addValue("Bearer \(refreshToken.token)", forHTTPHeaderField: "Authorization")
        } else if !accessToken.token.isEmpty && !ignoreJwtAuth {
            request.addValue("Bearer \(accessToken.token)", forHTTPHeaderField: "Authorization")
            
        }
        return request
    }
    
    private func formRefreshTokensRequest() -> URLRequest {
        return formRequest(url: Endpoint.refreshTokens.absoluteURL, refreshTokens: true)
    }
    
    private func renewAuthHeader(request: URLRequest) -> URLRequest {
        var newRequest = request
        newRequest.setValue("Bearer \(accessToken.token)", forHTTPHeaderField: "Authorization")
        return newRequest
    }
    
    private func handleAuthResponse(response: Result<User>, onResult: @escaping (Result<User>) -> Void) {
        if case .success(let user) = response {
            self.onTokensRefreshed(tokens: user.data!.getTokensInfo())
        }
        onResult(response)
    }
    
    func register(authBody: AuthBody, onResult: @escaping (Result<User>) -> Void) {
        let url = Endpoint.register.absoluteURL
        let body = try! JSONEncoder().encode(authBody) //TODO: handle serializaztion error
        let request = formRequest(url: url, data: body, method: "POST", ignoreJwtAuth: true)
        self.doRequest(request: request) { [self] result in
            self.handleAuthResponse(response: result, onResult: onResult)
        }
    }
    
    func login(authBody: AuthBody, onResult: @escaping (Result<User>) -> Void) {
        let url = Endpoint.login.absoluteURL
        let body = try! JSONEncoder().encode(authBody) //TODO: handle serializaztion error
        let request = formRequest(url: url, data: body, method: "POST", ignoreJwtAuth: true)
        self.doRequest(request: request) { [self] result in
            self.handleAuthResponse(response: result, onResult: onResult)
        }
    }
    
//    /// Функция получения пользователей вызываемая из класса
//    /// - Parameter onResult: массив пользователей или null
//    func getDevelopers(onResult: @escaping (Result<Developer>) -> Void) {
//        let url = Endpoint.getDevelopers.absoluteURL
//        let request = formRequest(url: url, data: Data(), method: "GET")
//        self.request(request: request, onResult: onResult)
//    }
    
    private var needReAuth: Bool {
        let current = Date().timestampMillis()
        let expires = accessToken.expireEt
        
        print("-----")
        print(current)
        print(expires)
        print(current + Requester.ACCESS_TOKEN_LIFE_THRESHOLD_SECONDS)
        
        print(refreshToken.token.isEmpty)
        print("-----")

        return current + Requester.ACCESS_TOKEN_LIFE_THRESHOLD_SECONDS > expires
    }
    
    func request<T: Decodable>(request: URLRequest, onResult: @escaping (Result<T>) -> Void) {
        print("request called")
        if (needReAuth && !refreshToken.token.isEmpty) {
            print("need to re-auth")
            authAndDoRequest(request: request, onResult: onResult)
        } else {
            print("no need to re-auth")
            doRequest(request: request, onResult: onResult)
        }
    }
    
    func authAndDoRequest<T: Decodable>(request: URLRequest, onResult: @escaping (Result<T>) -> Void) {
        print("authAndDoRequest " + (request.url?.absoluteString ?? ""))
        let refreshRequest = formRefreshTokensRequest()
        let task = URLSession.shared.dataTask(with: refreshRequest) { [self] (data, response, error) -> Void in
            if let error = error {
                print("error refresh tokens: ", error)
                DispatchQueue.main.async { onResult(.networkError(error.localizedDescription)) }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                //should never happen
                DispatchQueue.main.async {
                    onResult(.authError(ErrorResponse(code: 0, message: Errors.ERR_CONVERTING_TO_HTTP_RESPONSE)))
                }
                return
            }
            guard let data = data else {
                //should never happen
                DispatchQueue.main.async {
                    onResult(.authError(ErrorResponse(code: httpResponse.statusCode, message: Errors.ERR_NIL_BODY)))
                }
                return
            }
            if httpResponse.isSuccessful() {
                do {
                    let response = try JSONDecoder().decode(TokensInfo.self, from: data)
                    print("parsed refresh response: \(response)")
                    onTokensRefreshed(tokens: response)
                    print("saved new tokens, now doing request: \(request.url?.absoluteString ?? "")")
                    let newRequest = renewAuthHeader(request: request)
                    doRequest(request: newRequest, onResult: onResult)
                    return
                } catch {
                    DispatchQueue.main.async {
                        //should never happen
                        let response = try! JSONDecoder().decode(Develop.self, from: data)
                        print("--")
                        print(response)
                        print("---------")
                        onResult(.authError(ErrorResponse(code: 0, message: Errors.ERR_PARSE_RESPONSE)))
                    }
                    return
                }
            } else {
                print("refresh tokens not successful")
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    print("error refresh tokens: ", errorResponse)
                    DispatchQueue.main.async {
                        onResult(.authError(errorResponse))
                    }
                    return
                } catch {
                    DispatchQueue.main.async {
                        onResult(.authError(ErrorResponse(code: 0, message: error.localizedDescription)))
                    }
                    return
                }
            }
        }
        task.resume()
    }
    
    func doRequest<T: Decodable>(request: URLRequest, onResult: @escaping (Result<T>) -> Void) {
        print("do request \(request.url?.absoluteString ?? "")")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                print("response error: ", error)
                DispatchQueue.main.async { onResult(.networkError(error.localizedDescription)) }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                //should never happen
                DispatchQueue.main.async { onResult(.networkError(Errors.ERR_CONVERTING_TO_HTTP_RESPONSE)) }
                return
            }
            
            guard let data = data else {
                //should never happen
                DispatchQueue.main.async {
                    onResult(.serverError(ErrorResponse(code: httpResponse.statusCode, message: Errors.ERR_NIL_BODY)))
                }
                return
            }
            print("respone code: \(httpResponse.statusCode)")
            if httpResponse.isSuccessful() {
                let responseBody: Result<T> = self.parseResponse(data: data)
                DispatchQueue.main.async { onResult(responseBody) }
            } else {
                let responseBody: Result<T> = self.parseError(data: data)
                DispatchQueue.main.async { onResult(responseBody) }
            }
        }
        task.resume()
    }
    
    private func parseResponse<T: Decodable>(data: Data) -> Result<T> {
        do {
            return .success(try JSONDecoder().decode(T.self, from: data))
        } catch {
            print("failed parsing successful response, parsing err: \(error)")
            return parseError(data: data)
        }
    }
    
    private func parseError<T>(data: Data) -> Result<T> {
        print("parsing error")
        do {
            
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            if (errorResponse.isAuth()) {
                return .authError(errorResponse)
            } else {
                return .serverError(errorResponse)
            }
        } catch {
            let user = try! JSONDecoder().decode(User.self, from: data)
            let error = user.error ?? Errors.ERR_PARSE_ERROR_RESPONSE
            return .serverError(ErrorResponse(code: 0, message: error))
        }
    }
    
}
