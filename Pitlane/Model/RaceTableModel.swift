//
//  Pitlane
//
//  Created by Adam Zapiór on 22/09/2023.
//

import Foundation

// MARK: - RaceTable
struct RaceTableModel: Codable {
    let season: String
    let races: [RaceModel]

    enum CodingKeys: String, CodingKey {
        case season
        case races = "Races"
    }
}

// MARK: - Race
struct RaceModel: Codable {
    let season, round: String
    let url: String
    let raceName: String
    let circuit: CircuitModel
    let date, time: String
    let firstPractice, secondPractice: PracticeDataModel?
    let thirdPractice: PracticeDataModel?
    let qualifying: PracticeDataModel?
    let sprint: PracticeDataModel?
    let results: [ResultModel]?
    


    enum CodingKeys: String, CodingKey {
        case season, round, url, raceName
        case circuit = "Circuit"
        case date, time
        case firstPractice = "FirstPractice"
        case secondPractice = "SecondPractice"
        case thirdPractice = "ThirdPractice"
        case qualifying = "Qualifying"
        case sprint = "Sprint"
        case results = "Results"
    }
}

// MARK: - FirstPractice
struct PracticeDataModel: Codable {
    let date, time: String
}

