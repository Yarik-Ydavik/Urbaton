//
//  Extensions.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension HTTPURLResponse {
    
    func isSuccessful() -> Bool {
        return statusCode >= 200 && statusCode <= 299
    }
}

extension Date {
    
    init(timestampMillis: Int64) {
        self.init(timeIntervalSince1970: TimeInterval(timestampMillis/1000))
    }
    
    func timestampMillis() -> Int64 {
        return timestamp() * 1000
    }
    
    func timestamp() -> Int64 {
        return Int64(self.timeIntervalSince1970)
    }
}
