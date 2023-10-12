//
//  F1Error.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 17/12/2022.
//

import Foundation



enum F1Error: String, Error {
    case invalidURL =  "Invalid request. Please check URL"
    case unableToComplete = "Unable to complete your request"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data revveiced from the server was invalid. Please try again"
}
