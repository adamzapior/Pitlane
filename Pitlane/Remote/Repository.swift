//
//  Respository.swift
//  Pitlane
//
//  Created by Adam Zapiór on 23/09/2023.
//

import Foundation
import Alamofire

enum myNetworkError: Error {
    case missingData
    case serverError(statusCode: Int)
    case unknown
    // ... any other specific errors you might encounter
    
    var localizedDescription: String {
        switch self {
        case .missingData:
            return "The expected data is missing."
        case .serverError(let statusCode):
            return "Received server error with status code: \(statusCode)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

class Repository {
    
    func getStandindigs() async -> NetworkResult<[StandingsModel]> {
        let result: NetworkResult<F1ApiModel> = await APIHandler.get(APIService.getStandings(year: "2023", standingsType: .driverStandings))
        switch result {
        case .success(let f1ApiModel):
            guard let standings = f1ApiModel.f1Data.standingsTable else {
                return .failure(NetworkError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            return .success([standings])
        case .failure(let error):
            return .failure(error)
        }
    }
}

