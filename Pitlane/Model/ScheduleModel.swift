//
//  ScheduleModel.swift
//  Pitlane
//
//  Created by Adam Zapiór on 12/11/2023.
//

import Foundation

struct ScheduleModel: Codable {
    let season: String
    let round: String
    let raceName: String
    let circuit: CircuitModel
    let date: Date
    let firstPractice: PracticeDataModel
    let secondPractice: PracticeDataModel?
    let thirdPractice: PracticeDataModel?
    let sprintQualifying: PracticeDataModel?
    let qualifying: PracticeDataModel
    let sprint: PracticeDataModel?
}

struct PracticeDataModel: Codable {
    let date: Date
}
