//
//  ResultsDto.swift
//  Pitlane
//
//  Created by Adam Zapiór on 23/09/2023.
//

import Foundation

// MARK: - Result
struct ResultModel: Codable {
    let number, position, positionText, points: String
    let driver: DriverModel
    let constructor: ConstructorModel
    let grid, laps, status: String
    let time: ResultTimeModel?
    let fastestLap: FastestLapModel?

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
struct FastestLapModel: Codable {
    let rank, lap: String
    let time: FastestLapTimeModel
    let averageSpeed: AverageSpeedModel

    enum CodingKeys: String, CodingKey {
        case rank, lap
        case time = "Time"
        case averageSpeed = "AverageSpeed"
    }
}

// MARK: - AverageSpeed
struct AverageSpeedModel: Codable {
    let units: Units
    let speed: String
}

enum Units: String, Codable {
    case kph = "kph"
}

// MARK: - FastestLapTime
struct FastestLapTimeModel: Codable {
    let time: String
}

// MARK: - ResultTime
struct ResultTimeModel: Codable {
    let millis, time: String
}
