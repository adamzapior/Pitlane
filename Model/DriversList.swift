//
//  Drivers.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 31/10/2022.
//

import UIKit

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
    let driverTable: DriverTable

  


    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case driverTable = "DriverTable"
    }
}


// MARK: - DriverTable
private struct DriverTable: Codable {
    let drivers: [Driver]

    enum CodingKeys: String, CodingKey {
        case drivers = "Drivers"
    }
}

// MARK: - Driver
private struct Driver: Codable {
    let driverID: String
    let url: String
    let givenName, familyName, dateOfBirth, nationality: String
    let permanentNumber, code: String?

    enum CodingKeys: String, CodingKey {
        case driverID = "driverId"
        case url, givenName, familyName, dateOfBirth, nationality, permanentNumber, code
    }
}




 


//MARK: - the ned

let decoder = JSONDecoder()

func coTosieDziejeKolezko() {
    
    guard let url = URL(string: "http://ergast.com/api/f1/drivers.json?limit=1000&offset=20") else {
        return
    }
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print(error.localizedDescription)
        }
        guard let data = data else {
            return
        }

    
    do {
        let driver = try decoder.decode(Welcome.self, from: data)
        print(driver.mrData.driverTable.drivers[10])
        
        for driver in driver.mrData.driverTable.drivers { print(driver.driverID.capitalized) }
        

    } catch {
    debugPrint(error)
}
    }.resume()
}

