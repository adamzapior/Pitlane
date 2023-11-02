//
//  APIService.swift
//  Pitlane
//
//  Created by Adam Zapiór on 23/09/2023.
//

import Foundation

protocol APIServiceProtocol {
    static func url(_ query: String) -> String
    
    static func getSchedule() -> String
    
    static func getStandings(year: String, standingsType: StandingsType) -> String
    
}

class APIService: APIServiceProtocol  {
    
    static func url(_ query: String) -> String {
        "https://ergast.com/api/f1/\(query).json"
    }
    
    static func getSchedule() -> String {
        url("current")
    }
    
    static func getStandings(year: String, standingsType: StandingsType) -> String {
        url("\(year)/\(standingsType.rawValue)")
    }
    
    // to edit
//    static func getSchedule(year: String) -> String {
//        url("\(year)")
//    }

    
}

enum StandingsType: String {
    case driverStandings
    case constructorStandings
}
