//
//  ScheduleModel.swift
//  Pitlane
//
//  Created by Adam Zapiór on 12/11/2023.
//

import Foundation

struct ScheduleModel: Codable {
    let round: String
    let raceName: String
    let circuit: CircuitModel1
    let date: Date
    let firstPractice: PracticeDataModel1
    let secondPractice: PracticeDataModel1
    let thirdPractice: PracticeDataModel1?
    let qualifying: PracticeDataModel1
    let sprint: PracticeDataModel1?
}

struct PracticeDataModel1: Codable {
    let date: Date
}
