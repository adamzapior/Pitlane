//
//  Respository.swift
//  Pitlane
//
//  Created by Adam Zapiór on 23/09/2023.
//

import Alamofire
import Foundation

class Repository {
    func getDriverStanding() async -> NetworkResult<[DriverStandingModel]> {
        let result: NetworkResult<F1ApiModel> = await APIHandler.get(APIService.getStandings(year: "2023", standingsType: .driverStandings))
        switch result {
        case .success(let f1ApiModel):
            guard let driverStandings = f1ApiModel.f1Data.standingsTable?.standingsLists.flatMap({ list in
                list.driverStandings ?? []
            }) else {
                return .failure(NetworkError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            return .success(driverStandings)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getConstructorStanding() async -> NetworkResult<[ConstructorStandingModel]> {
        let result: NetworkResult<F1ApiModel> = await APIHandler.get(APIService.getStandings(year: "2023", standingsType: .constructorStandings))
        switch result {
        case .success(let f1ApiModel):
            guard let constructorStanding = f1ApiModel.f1Data.standingsTable?.standingsLists.flatMap({ list in
                list.constructorStandings ?? []
            }) else {
                return .failure(NetworkError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            return .success(constructorStanding)
        case .failure(let error):
            return .failure(error)
        }
    }
}
