//
//  StandingsDto.swift
//  Pitlane
//
//  Created by Adam Zapiór on 22/09/2023.
//

import Foundation

// MARK: - StandingsTable
struct StandingsModel: Codable {
    let season: String
    let standingsLists: [StandingsListModel]

    enum CodingKeys: String, CodingKey {
        case season
        case standingsLists = "StandingsLists"
    }
}

// MARK: - StandingsList
struct StandingsListModel: Codable {
    let season, round: String
    let driverStandings: [DriverStandingModel]?
    let constructorStandings: [ConstructorStandingModel]?

    enum CodingKeys: String, CodingKey {
        case season, round
        case driverStandings = "DriverStandings"
        case constructorStandings = "ConstructorStandings"
    }
}

// MARK: - DriverStanding
struct DriverStandingModel: Codable {
    let position, positionText, points, wins: String
    let driver: DriverModel
    let constructors: [ConstructorModel]  // arayy beforeee

    enum CodingKeys: String, CodingKey {
        case position, positionText, points, wins
        case driver = "Driver"
        case constructors = "Constructors"
    }
}

// MARK: - ConstructorStanding
struct ConstructorStandingModel: Codable {
    let position, positionText, points, wins: String
    let constructor: ConstructorModel

    enum CodingKeys: String, CodingKey {
        case position, positionText, points, wins
        case constructor = "Constructor"
    }
}

