//
//  ScheduleDto.swift
//  Pitlane
//
//  Created by Adam Zapiór on 11/11/2023.
//


// MARK: - Welcome
struct ScheduleDto: Codable {
    let mrData: ScheduleMRDataDto

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct ScheduleMRDataDto: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit, offset, total: String
    let raceTable: ScheduleRaceTableDto

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case raceTable = "RaceTable"
    }
}

// MARK: - RaceTable
struct ScheduleRaceTableDto: Codable {
    let season: String
    let races: [ScheduleRaceDto]

    enum CodingKeys: String, CodingKey {
        case season
        case races = "Races"
    }
}

// MARK: - Race
struct ScheduleRaceDto: Codable {
    let season: String
    let round: String
    let url: String
    let raceName: String
    let circuit: CircuitDto
    let date, time: String
    let firstPractice, secondPractice: PracticeDataDto
    let thirdPractice: PracticeDataDto?
    let qualifying: PracticeDataDto
    let sprint: PracticeDataDto?

    enum CodingKeys: String, CodingKey {
        case season, round, url, raceName
        case circuit = "Circuit"
        case date, time
        case firstPractice = "FirstPractice"
        case secondPractice = "SecondPractice"
        case thirdPractice = "ThirdPractice"
        case qualifying = "Qualifying"
        case sprint = "Sprint"
    }
}

// MARK: - FirstPractice
struct PracticeDataDto: Codable {
    let date, time: String
}
