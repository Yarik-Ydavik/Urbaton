//
//  IdentifiableAlert.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import Foundation

import SwiftUI

struct IdentifiableAlert: Identifiable {
    var id: String
    var alert: () -> Alert
    
    static func build(id: String, title: String, message: String) -> IdentifiableAlert {
        return IdentifiableAlert(id: id, alert: {
            Alert(
                title: Text(LocalizedStringKey(title)),
                message: Text(message)
            )
        })
    }
    
    static func buildForError(id: String, message: String) -> IdentifiableAlert {
        return IdentifiableAlert(id: id, alert: {
            Alert(
                title: Text("Oшибка"),
                message: Text(message)
            )
        })
    }
    
    static func networkError() -> IdentifiableAlert {
        return buildForError(id: "network_err", message: "Пожалуйста проверьте ваше интернет соединение и попробуйте снова")
    }
    
}
