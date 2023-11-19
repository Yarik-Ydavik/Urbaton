//
//  Errors.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation

class Errors {
    
    // внутренние
    static let ERR_SERIALIZING_REQUEST = "error_serializing_request"
    static let ERR_CONVERTING_TO_HTTP_RESPONSE = "error_converting_response_to_http_response"
    static let ERR_PARSE_RESPONSE = "error_parsing_response"
    static let ERR_NIL_BODY = "error_nil_body"
    static let ERR_PARSE_ERROR_RESPONSE = "error_parsing_error_response"
    
    // ошибки сервера
    static let ERR_USER_EXIST = "Пользоватлеь с таким мылом уже зарегестрирован"
    static let ERR_USER_NOT_EXIST = "Пользователь не был найден"
    static let ERR_WRONG_CREDENTIALS = "неверные учетные данные"
    static let ERR_MISSING_AUTH_HEADER = "отсутствует заголовок auth или неправильный формат заголовка"
    static let ERR_INVALID_ACCESS_TOKEN = "недопустимый токен доступа"
    static let ERR_ACCESS_TOKEN_EXPIRED = "срок действия токена доступа истек"
    static let ERR_INVALID_REFRESH_TOKEN = "недопустимый токен обновления"
    static let ERR_REFRESH_TOKEN_EXPIRED = "срок действия токена обновления истек"
    
    static func messageFor(err: String) -> String {
        switch err {
        case ERR_USER_EXIST:
            return "Пользователь с указанным логином уже существует"
        case ERR_USER_NOT_EXIST:
            return "Пользователь с указанным логином не существует"
        case ERR_WRONG_CREDENTIALS:
            return "Введен неправильный логин или пароль"
        
        default:
            return "Произошла ошибка. Пожалуйста, проверьте ваше интернет-соединение и повторите попытку"
        }
    }
    
    static func isAuthError(err: String) -> Bool {
        return err == ERR_MISSING_AUTH_HEADER || err == ERR_INVALID_ACCESS_TOKEN ||
        err == ERR_INVALID_REFRESH_TOKEN || err == ERR_ACCESS_TOKEN_EXPIRED || err == ERR_REFRESH_TOKEN_EXPIRED
    }
}
