//
//  Result.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation

enum Result<T> {
    case success(_ response: T)
    case serverError(_ err: ErrorResponse)
    case authError(_ err: ErrorResponse)
    case networkError(_ err: String)
}
