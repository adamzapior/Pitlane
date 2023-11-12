//
//  ConstructorStandingDto.swift
//  Pitlane
//
//  Created by Adam Zapiór on 11/11/2023.
//

import Foundation


struct ConstructorStandingDto: Codable {
    let mrData: ConstructorMRDataDto

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct ConstructorMRDataDto: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit, offset, total: String
    let standingsTable: ConstructorStandingsTableDto

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case standingsTable = "StandingsTable"
    }
}

// MARK: - StandingsTable
struct ConstructorStandingsTableDto: Codable {
    let season: String
    let standingsLists: [ConstructorStandingsListDto]

    enum CodingKeys: String, CodingKey {
        case season
        case standingsLists = "StandingsLists"
    }
}

// MARK: - StandingsList
struct ConstructorStandingsListDto: Codable {
    let season, round: String
    let constructorStandings: [ConstructorStandingDataDto]

    enum CodingKeys: String, CodingKey {
        case season, round
        case constructorStandings = "ConstructorStandings"
    }
}

// MARK: - ConstructorStanding
struct ConstructorStandingDataDto: Codable {
    let position, positionText, points, wins: String
    let constructor: ConstructorDto

    enum CodingKeys: String, CodingKey {
        case position, positionText, points, wins
        case constructor = "Constructor"
    }
}
