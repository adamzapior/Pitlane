//
//  LocationModel.swift
//  Pitlane
//
//  Created by Adam Zapiór on 23/09/2023.
//

import Foundation

// MARK: - Location
struct LocationModel: Codable {
    let lat, long, locality, country: String
}
