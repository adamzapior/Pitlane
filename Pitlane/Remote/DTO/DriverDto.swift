//
//  DriverDto.swift
//  Pitlane
//
//  Created by Adam Zapiór on 11/11/2023.
//

import Foundation

struct DriverDto: Codable {
    let driverID: String
    let permanentNumber: String?
    let code: String
    let url: String
    let givenName, familyName, dateOfBirth, nationality: String

    enum CodingKeys: String, CodingKey {
        case driverID = "driverId"
        case permanentNumber, code, url, givenName, familyName, dateOfBirth, nationality
    }
}
