//
//  StringDateFormatter.swift
//  Pitlane
//
//  Created by Adam Zapiór on 07/11/2023.
//

import Foundation

extension String {
    
    func combineDate(date dateString: String, time timeString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd' 'H:mm:ssZ" // Dostosuj format daty i czasu do formatu używanego w twoim API
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ustawienie lokalizacji na POSIX jest dobrą praktyką przy pracy z datami w formacie ISO
        dateFormatter.timeZone = TimeZone(identifier: "UTC") // Ustawienie strefy czasowej na UTC

        let combinedString = "\(dateString) \(timeString)"
        return dateFormatter.date(from: combinedString)
    }
    
    
    func scheduleDateFormatter() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMM"
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            return outputFormatter.string(from: date).uppercased()
        } else {
            return ""
        }
    }
    
    func scheduleDetailsTimeFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date).uppercased()
        } else {
            return ""
        }
    }
}
