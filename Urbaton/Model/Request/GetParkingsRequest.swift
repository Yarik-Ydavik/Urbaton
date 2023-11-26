//
//  GetParkingsRequest.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 25.11.2023.
//

import Foundation

struct GeetParkingsRequest: Codable {
    let lat, long: Double?
    let range: Int?
}
