//
//  ResultDto.swift
//  Pitlane
//
//  Created by Adam Zapiór on 11/11/2023.
//

// MARK: - Welcome
struct RaceResultDto: Codable {
    let mrData: RaceResultMRDataDto

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct RaceResultMRDataDto: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit, offset, total: String
    let raceTable: RaceTableDto

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case raceTable = "RaceTable"
    }
}

// MARK: - RaceTable
struct RaceTableDto: Codable {
    let season: String
    let races: [RaceDto]

    enum CodingKeys: String, CodingKey {
        case season
        case races = "Races"
    }
}

// MARK: - Race
struct RaceDto: Codable {
    let season, round: String
    let url: String
    let raceName: String
    let circuit: CircuitDto
    let date, time: String
    let results: [RaceResultDataDto]

    enum CodingKeys: String, CodingKey {
        case season, round, url, raceName
        case circuit = "Circuit"
        case date, time
        case results = "Results"
    }
}

// MARK: - Result
struct RaceResultDataDto: Codable {
    let number, position, positionText, points: String
    let driver: DriverDto
    let constructor: ConstructorDto
    let grid, laps, status: String
    let time: RaceResultTimeDto?
    let fastestLap: RaceFastestLapDto

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
struct RaceFastestLapDto: Codable {
    let rank, lap: String
    let time: RaceFastestLapTimeDto
    let averageSpeed: RaceAverageSpeedDto

    enum CodingKeys: String, CodingKey {
        case rank, lap
        case time = "Time"
        case averageSpeed = "AverageSpeed"
    }
}

// MARK: - AverageSpeed
struct RaceAverageSpeedDto: Codable {
    let units: Units
    let speed: String
}

//
//enum Units: String, Codable {
//    case kph = "kph"
//}

// MARK: - FastestLapTime
struct RaceFastestLapTimeDto: Codable {
    let time: String
}

// MARK: - ResultTime
struct RaceResultTimeDto: Codable {
    let millis, time: String
}
