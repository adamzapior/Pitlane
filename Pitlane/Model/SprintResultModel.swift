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
    let circuit: CircuitModel1
    let date: Date
    let sprintResults: [SprintResultDataModel]
}


// MARK: - SprintResult
struct SprintResultDataModel: Codable {
    let position: String
    let points: String
    let driver: DriverModel1
    let constructor: ConstructorModel1
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
