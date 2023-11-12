//
//  SprintResultDto.swift
//  Pitlane
//
//  Created by Adam Zapiór on 12/11/2023.
//

import Foundation

struct SprintResultDto: Codable {
    let mrData: SprintMRDataDto

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct SprintMRDataDto: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit, offset, total: String
    let raceTable: SprintRaceTableDto

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case raceTable = "RaceTable"
    }
}

// MARK: - RaceTable
struct SprintRaceTableDto: Codable {
    let season: String
    let races: [SprintRaceDto]

    enum CodingKeys: String, CodingKey {
        case season
        case races = "Races"
    }
}

// MARK: - Race
struct SprintRaceDto: Codable {
    let season, round: String
    let url: String
    let raceName: String
    let circuit: CircuitDto
    let date, time: String
    let sprintResults: [SprintResultDataDto]

    enum CodingKeys: String, CodingKey {
        case season, round, url, raceName
        case circuit = "Circuit"
        case date, time
        case sprintResults = "SprintResults"
    }
}


// MARK: - SprintResult
struct SprintResultDataDto: Codable {
    let number, position, positionText, points: String
    let driver: DriverDto
    let constructor: ConstructorDto
    let grid, laps: String
    let status: String
    let time: SprintResultTimeDto?
    let fastestLap: SprintFastestLapDto?

    enum CodingKeys: String, CodingKey {
        case number, position, positionText, points
        case driver = "Driver"
        case constructor = "Constructor"
        case grid, laps, status
        case time = "Time"
        case fastestLap = "FastestLap"
    }
}


// MARK: - FastestLap
struct SprintFastestLapDto: Codable {
    let lap: String
    let time: SprintFastestLapTimeDto

    enum CodingKeys: String, CodingKey {
        case lap
        case time = "Time"
    }
}

// MARK: - FastestLapTime
struct SprintFastestLapTimeDto: Codable {
    let time: String
}

//enum Status: String, Codable {
//    case accident = "Accident"
//    case collisionDamage = "Collision damage"
//    case finished = "Finished"
//}

// MARK: - SprintResultTime
struct SprintResultTimeDto: Codable {
    let millis, time: String
}
