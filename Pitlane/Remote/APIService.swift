//
//  APIService.swift
//  Pitlane
//
//  Created by Adam Zapiór on 23/09/2023.
//

import Foundation

protocol APIServiceProtocol {
    static func url(_ query: String, limit: Int, offset: Int) -> String
    
    static func getSchedule() -> String
    
    static func getResults() -> String
    
    static func getStandings(year: String, standingsType: StandingsType) -> String
}

class APIService: APIServiceProtocol {
    static func url(_ query: String, limit: Int, offset: Int) -> String {
        "https://ergast.com/api/f1/\(query).json?limit=\(limit.formatted())&offset=\(offset.formatted())"
    }
    
    static func getSchedule() -> String {
        url("current", limit: 100, offset: 0)
    }
    
    static func getResults() -> String {
        url("current/results", limit: 500, offset: 0)
    }
    
    static func getSprintResult() -> String {
        url("current/sprint", limit: 500, offset: 0)
    }
    
    static func getQualifyingResult() -> String {
        url("current/qualifying", limit: 500, offset: 0)
    }
    
    static func getStandings(year: String, standingsType: StandingsType) -> String {
        url("\(year)/\(standingsType.rawValue)", limit: 100, offset: 0)
    }
}

enum StandingsType: String {
    case driverStandings
    case constructorStandings
}
