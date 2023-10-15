//
//  Respository.swift
//  Pitlane
//
//  Created by Adam Zapiór on 23/09/2023.
//

import Alamofire
import Foundation

class Repository {
    func getStandindigs() async -> NetworkResult<[DriverStandingModel]> {
        let result: NetworkResult<F1ApiModel> = await APIHandler.get(APIService.getStandings(year: "2023", standingsType: .driverStandings))
        switch result {
        case .success(let f1ApiModel):

            guard let standings = f1ApiModel.f1Data.standingsTable?.standingsLists.flatMap({ list in
                list.driverStandings ?? []
            }) else {
                return .failure(NetworkError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            return .success(standings)
        case .failure(let error):
            return .failure(error)
        }
    }
}
