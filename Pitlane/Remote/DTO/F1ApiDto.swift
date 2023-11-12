//
//  F1ApiDTO.swift
//  Pitlane
//
//  Created by Adam Zapiór on 11/11/2023.
//

import Foundation

struct F1ApiDto: Codable {
    let f1Data: F1DataDto

    enum CodingKeys: String, CodingKey {
        case f1Data = "MRData"
    }
}

struct F1DataDto: Codable {
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
