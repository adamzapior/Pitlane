//
//  CircuitModel.swift
//  Pitlane
//
//  Created by Adam Zapiór on 23/09/2023.
//

import Foundation

struct CircuitModel: Codable {
    let circuitID: String
    let circuitName: String
    let location: LocationModel
}
