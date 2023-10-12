//
//  F1API.swift
//  Pitlane
//
//  Created by Adam Zapiór on 22/09/2023.
//

import Foundation

struct F1ApiModel: Codable {
    let f1Data: F1DataModel

    enum CodingKeys: String, CodingKey {
        case f1Data = "MRData"
    }
}

struct F1DataModel: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit, offset, total: String
    let standingsTable: StandingsModel?
    let raceTable: RaceTableModel?

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case standingsTable = "StandingsTable"
        case raceTable = "RaceTable"
    }
}
