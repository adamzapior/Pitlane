//
//  CircuitDto.swift
//  Pitlane
//
//  Created by Adam Zapiór on 11/11/2023.
//

import Foundation

struct CircuitDto: Codable {
    let circuitID: String
    let url: String
    let circuitName: String
    let location: LocationDto

    enum CodingKeys: String, CodingKey {
        case circuitID = "circuitId"
        case url, circuitName
        case location = "Location"
    }
}
