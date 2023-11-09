//
//  CountryFlagProvider.swift
//  Pitlane
//
//  Created by Adam Zapiór on 09/11/2023.
//

import FlagKit
import Foundation
import UIKit

class CountryFlagProvider {
    static let shared = CountryFlagProvider()
    
    let countryMapping: [String: String] = [
        "Bahrain": "BH",
        "Saudi Arabia": "SA",
        "Australia": "AU",
        "Azerbaijan": "AZ",
        "USA": "US",
        "Monaco": "MC",
        "Spain": "ES",
        "Canada": "CA",
        "Austria": "AT",
        "UK": "UK",
        "Hungary": "HU",
        "Belgium": "BE",
        "Netherlands": "NL",
        "Italy": "IT",
        "Singapore": "SG",
        "Japan": "JP",
        "Qatar": "QA",
        "Mexico": "MX",
        "Brazil": "BR",
        "United States": "US",
        "UAE": "AE",
    ]
    
    let nationalityMapping: [String: String] = [
        "Austrian": "AT",
        "Swiss": "CH",
        "British": "GB",
        "Mexican": "MX",
        "Spanish": "ES",
        "Monegasque": "MC",
        "Australian": "AU",
        "Canadian": "CA",
        "French": "FR",
        "Thai": "TH",
        "Finnish": "FI",
        "German": "DE",
        "Chinese": "CN",
        "Japanese": "JP",
        "Danish": "DK",
        "New Zealander": "NZ",
        "American": "US",
        "Dutch": "NL",
        "Italian": "IT",
    ]
    
    private init() {}
    
    func countryFlag(for countryName: String) -> UIImage? {
        guard let countryCode = countryMapping[countryName],
              let flag = Flag(countryCode: countryCode)
        else {
            return nil
        }
        return flag.image(style: .none)
    }
    
    func nationalityFlag(for nationality: String) -> UIImage? {
        guard let countryCode = nationalityMapping[nationality],
              let flag = Flag(countryCode: countryCode)
        else {
            return nil
        }
        return flag.image(style: .none)
    }
}
