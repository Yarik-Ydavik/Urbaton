//
//  CreateEventResponse.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 25.11.2023.
//

import Foundation

struct CreateEventResponse: Codable, Equatable, Identifiable, Hashable {
    static func == (lhs: CreateEventResponse, rhs: CreateEventResponse) -> Bool {
        lhs.id == rhs.id
    }
    
    let id, name, cityName: String
    let location: locationRequest
    let description: String
    let date: String
    let maxCountPlaces: Int
    var currentCountPlaces: Int
    let images: [String]
    
    func hash(into hasher: inout Hasher) {
        
    }
}

