//
//  DriverModel.swift
//  Pitlane
//
//  Created by Adam Zapiór on 23/09/2023.
//

import Foundation

struct DriverModel: Codable {
    let driverID, permanentNumber, code: String
    let url: String
    let givenName, familyName, dateOfBirth, nationality: String

    enum CodingKeys: String, CodingKey {
        case driverID = "driverId"
        case permanentNumber, code, url, givenName, familyName, dateOfBirth, nationality
    }
}


struct DriverModel1: Codable {
    let driverID: String
    let name: String
    let surname: String
    let nationality: String
}
