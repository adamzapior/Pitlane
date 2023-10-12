//
//  CircuitModel.swift
//  Pitlane
//
//  Created by Adam Zapiór on 23/09/2023.
//

import Foundation

// MARK: - Circuit
struct CircuitModel: Codable {
    let circuitID: String
    let url: String
    let circuitName: String
    let location: LocationModel

    enum CodingKeys: String, CodingKey {
        case circuitID = "circuitId"
        case url, circuitName
        case location = "Location"
    }
}

