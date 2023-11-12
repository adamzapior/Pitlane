//
//  QualifyingResultDto.swift
//  Pitlane
//
//  Created by Adam Zapiór on 12/11/2023.
//

import Foundation


// MARK: - Welcome
struct QualifyingResultDto: Codable {
    let mrData: QualifyingMRDataDto

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct QualifyingMRDataDto: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit, offset, total: String
    let raceTable: QualifyingRaceTableDto

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case raceTable = "RaceTable"
    }
}

// MARK: - RaceTable
struct QualifyingRaceTableDto: Codable {
    let season: String
    let races: [QualifyingDto]

    enum CodingKeys: String, CodingKey {
        case season
        case races = "Races"
    }
}

// MARK: - Race
struct QualifyingDto: Codable {
    let season, round: String
    let url: String
    let raceName: String
    let circuit: CircuitDto
    let date, time: String
    let qualifyingResults: [QualifyingResultDataDto]

    enum CodingKeys: String, CodingKey {
        case season, round, url, raceName
        case circuit = "Circuit"
        case date, time
        case qualifyingResults = "QualifyingResults"
    }
}

// MARK: - QualifyingResult
struct QualifyingResultDataDto: Codable {
    let number, position: String
    let driver: DriverDto
    let constructor: ConstructorDto
    let q1: String
    let q2, q3: String?

    enum CodingKeys: String, CodingKey {
        case number, position
        case driver = "Driver"
        case constructor = "Constructor"
        case q1 = "Q1"
        case q2 = "Q2"
        case q3 = "Q3"
    }
}
