//
//  GetParkingsResponse.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 25.11.2023.
//

import Foundation

// MARK: - GetParkingsResponse
struct GetParkingsResponse: Codable {
    let data: [Datum]?
    let error: String?
}

// MARK: - Datum
struct Datum: Codable, Equatable, Identifiable {
    var id = UUID().uuidString
    
    
   
    let idParking: Int?
    let lat, long, location: String?
    let hasCam: Bool?
    let idType, idOwner: Int?
    let type, spots: String?

    enum CodingKeys: String, CodingKey {
        case idParking = "id_parking"
        case lat, long, location
        case hasCam = "has_cam"
        case idType = "id_type"
        case idOwner = "id_owner"
        case type, spots
    }
}
