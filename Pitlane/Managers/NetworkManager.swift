////
////  NetworkManager.swift
////  Pitlane
////
////  Created by Adam Zapiór on 19/05/2023.
////
//
//import Foundation
//import Alamofire
//
//enum Endpoint: String {
//    case currentSeason
//    case driversStanding
//    case constructorStanding
//}
//
//
//class NetworkManager: ObservableObject {
//    
//    static let shared = NetworkManager()
//    
//    
//    let path: String = "https://ergast.com/api/f1/"
//    
//   
//    var raceNumber: String = "1"
//    
//   
//    
//    
//    @Published var standingsDrivers: [DriverStandingInfo]? = nil
//    @Published var standingsConstructors: [ConstructorStandings]? = nil
//    
//
//    init() {
//        Task {
//            let standingDrivers = try! await getStandingsDrivers().get()
//            await MainActor.run {
//                self.standingsDrivers = standingDrivers
//            }
//        }
//    }
//    
//    func getStandingsDrivers() async -> Result<[DriverStandings], AFError> {
//        await AF.request("https://ergast.com/api/f1/current/driverStandings.json").response
//            .serializingDecodable(DriverStandings.self)
//            .result
//            .map {
//                $0.mrData.standingsTable.standingsLists
//                    .map { standingsList in
//                        standingsList.driverStandings
//                    }
//                    .reduce([], +)
//            }
//    }
//    
//    
//    func getStandingConstructors() async -> Result<[ConstructorStanding], AFError> {
//        await AF.request("https://ergast.com/api/f1/current/driverStandings.json")
//            .serializingDecodable(ConstructorStandings.self)
//            .result
//            .map {
//                
//            }
//
//    }
//
//   
//}
