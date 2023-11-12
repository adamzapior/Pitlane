//
//  DriverStandingDto.swift
//  Pitlane
//
//  Created by Adam Zapiór on 11/11/2023.
//

import Foundation


// MARK: - Welcome
struct DriverStandingDto: Codable {
    let mrData: DriverStandingMRDataDto

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct DriverStandingMRDataDto: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit, offset, total: String
    let standingsTable: DriverStandingsTableDto

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case standingsTable = "StandingsTable"
    }
}

// MARK: - StandingsTable
struct DriverStandingsTableDto: Codable {
    let season: String
    let standingsLists: [DriverStandingsListDto]

    enum CodingKeys: String, CodingKey {
        case season
        case standingsLists = "StandingsLists"
    }
}

// MARK: - StandingsList
struct DriverStandingsListDto: Codable {
    let season, round: String
    let driverStandings: [DriverStandingDataDto]

    enum CodingKeys: String, CodingKey {
        case season, round
        case driverStandings = "DriverStandings"
    }
}

// MARK: - DriverStanding
struct DriverStandingDataDto: Codable {
    let position, positionText, points, wins: String
    let driver: DriverDto
    let constructors: [ConstructorDto]

    enum CodingKeys: String, CodingKey {
        case position, positionText, points, wins
        case driver = "Driver"
        case constructors = "Constructors"
    }
}
