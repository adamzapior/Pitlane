//
//  ConstructorModel.swift
//  Pitlane
//
//  Created by Adam Zapiór on 23/09/2023.
//

import Foundation

struct ConstructorModel: Codable {
    let constructorID: String
    let name: String
    let nationality: String
    var driver1code: String?
    var driver2code: String?
}
