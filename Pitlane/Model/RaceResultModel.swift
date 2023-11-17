//
//  RaceResultsModel.swift
//  Pitlane
//
//  Created by Adam Zapiór on 12/11/2023.
//

import Foundation

// MARK: - Race
struct RaceResultModel: Codable {
    let round: String
    let raceName: String
    let circuit: CircuitModel
    let date: Date
    let results: [RaceResultDataModel]
}

// MARK: - Result
struct RaceResultDataModel: Codable {
    let position, points: String
    let driver: DriverModel
    let constructor: ConstructorModel
    let grid, laps, status: String
    let time: RaceResultTimeModel?
//    let fastestLap: RaceResultFastestLapModel
}

//// MARK: - FastestLap
//struct RaceResultFastestLapModel: Codable {
//    let rank, lap: String
//    let time: RaceResultFastestLapTimeModel
//}
//
//// MARK: - FastestLapTime
//struct RaceResultFastestLapTimeModel: Codable {
//    let time: String
//}

// MARK: - ResultTime
struct RaceResultTimeModel: Codable {
    let millis, time: String
}
