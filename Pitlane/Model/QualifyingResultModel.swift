//
//  QualifyingResultModel.swift
//  Pitlane
//
//  Created by Adam Zapiór on 12/11/2023.
//

import Foundation

struct QualifyingResultModel: Codable {
    let round: String
    let raceName: String
    let circuit: CircuitModel1
    let date: Date
    let qualifyingResults: [QualifyingResultDataModel]


}

struct QualifyingResultDataModel: Codable {
    let number, position: String
    let driver: DriverModel1
    let constructor: ConstructorModel1
    let q1: String
    let q2: String?
    let q3: String?
}
