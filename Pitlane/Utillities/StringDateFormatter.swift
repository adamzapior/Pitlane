//
//  StringDateFormatter.swift
//  Pitlane
//
//  Created by Adam Zapiór on 07/11/2023.
//

import Foundation


extension Date {
    func convertDateToScheduleString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self).uppercased()
    }
    
    func convertToScheduleDetails() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd MMM - h:mm a"
        return dateFormatter.string(from: self).uppercased()
    }
}

extension String {
    
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
