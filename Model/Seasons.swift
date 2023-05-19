//
//  Seasons.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 03/11/2022.
//
import Foundation

// MARK: - Welcome
private struct Welcome: Codable {
    let mrData: MRData

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
 private struct MRData: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit, offset, total: String
    let seasonTable: SeasonTable

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case seasonTable = "SeasonTable"
    }
}

// MARK: - SeasonTable
private struct SeasonTable: Codable {
    let seasons: [Season]

    enum CodingKeys: String, CodingKey {
        case seasons = "Seasons"
    }
}

// MARK: - Season
 private struct Season: Codable {
    let season: String
    let url: String
}

//MARK: - the ned

