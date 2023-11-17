

import Foundation


struct DriverStandingModel: Codable {
    let position: String
    let points: String
    let driver: DriverModel
    let constructors: ConstructorModel
}
