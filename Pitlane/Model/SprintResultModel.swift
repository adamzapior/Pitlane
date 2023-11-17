//
//  SprintResultsModel.swift
//  Pitlane
//
//  Created by Adam Zapiór on 12/11/2023.
//

import Foundation

struct SprintResultModel: Codable {
    let round: String
    let raceName: String
    let circuit: CircuitModel
    let date: Date
    let sprintResults: [SprintResultDataModel]
}


// MARK: - SprintResult
struct SprintResultDataModel: Codable {
    let position: String
    let points: String
    let driver: DriverModel
    let constructor: ConstructorModel
    let grid: String
    let laps: String
    let status: String
    let time: SprintResultTimeModel?
}


// MARK: - SprintResultTime
struct SprintResultTimeModel: Codable {
    let millis: String
    let time: String
}
