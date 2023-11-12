//
//  LocationDto.swift
//  Pitlane
//
//  Created by Adam Zapiór on 11/11/2023.
//

import Foundation

struct LocationDto: Codable {
    let lat, long, locality, country: String
}
