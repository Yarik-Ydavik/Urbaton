//
//  ElementProfile.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 26.11.2023.
//

import Foundation

struct ElementProfile: Identifiable, Hashable {
    let id = UUID()
    let image: String
    let name: String
    let description: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ElementProfile, rhs: ElementProfile) -> Bool {
        return lhs.id == rhs.id
    }
}

