//
//  Respository.swift
//  Pitlane
//
//  Created by Adam Zapiór on 23/09/2023.
//

import Alamofire
import Foundation

protocol RepositoryProtocol {
    func getSchedule() async -> NetworkResult<[ScheduleModel]>
    
    func getRaceResult() async -> NetworkResult<[RaceResultModel]>
    
    func getQualifyingResult() async -> NetworkResult<[QualifyingResultModel]>
    
    func getSprintResult() async -> NetworkResult<[SprintResultModel]>
    
    func getDriverStandings() async -> NetworkResult<[DriverStandingModel]>
    
    func getConstructorStandings() async -> NetworkResult<[ConstructorStandingModel]>
}

class Repository: RepositoryProtocol {
    func getSchedule() async -> NetworkResult<[ScheduleModel]> {
        let result: NetworkResult<ScheduleDto> = await APIHandler.get(APIService.getSchedule())
        switch result {
        case .success(let dto):
            let schedule = dto.mrData.raceTable.races.map { dto -> ScheduleModel in
                
                let firstPracticeDate = combineDate(date: dto.firstPractice.date, time: dto.firstPractice.time)
                let secondPracticeDate = combineDate(date: dto.secondPractice.date, time: dto.secondPractice.time)
                let qualifyingDate = combineDate(date: dto.qualifying.date, time: dto.qualifying.time)
                let raceDate = combineDate(date: dto.date, time: dto.time)
          
                /// Optional practice data
                var thirdPracticeDate: Date? = nil
                if let thirdPractice = dto.thirdPractice {
                    thirdPracticeDate = combineDate(date: thirdPractice.date, time: thirdPractice.time)
                }
                
                var sprintDate: Date? = nil
                if let sprint = dto.sprint {
                    sprintDate = combineDate(date: sprint.date, time: sprint.time)
                }
                
                /// Return schedule if sprint exsist
                if dto.sprint != nil {
                    return ScheduleModel(season: dto.season,
                                         round: dto.round,
                                         raceName: dto.raceName,
                                         circuit: createCircuitModel(from: dto.circuit),
                                         date: raceDate,
                                         firstPractice: PracticeDataModel(date: firstPracticeDate),
                                         secondPractice: nil,
                                         thirdPractice: nil,
                                         sprintQualifying: PracticeDataModel(date: secondPracticeDate),
                                         qualifying: PracticeDataModel(date: qualifyingDate),
                                         sprint: PracticeDataModel(date: sprintDate!))
                }
                /// Return schedule without sprint
                else {
                    return ScheduleModel(season: dto.season,
                                         round: dto.round,
                                         raceName: dto.raceName,
                                         circuit: createCircuitModel(from: dto.circuit),
                                         date: raceDate,
                                         firstPractice: PracticeDataModel(date: firstPracticeDate),
                                         secondPractice: PracticeDataModel(date: secondPracticeDate),
                                         thirdPractice: PracticeDataModel(date: thirdPracticeDate!),
                                         sprintQualifying: nil,
                                         qualifying: PracticeDataModel(date: qualifyingDate),
                                         sprint: nil)
                }
            }
            return .success(schedule)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getRaceResult() async -> NetworkResult<[RaceResultModel]> {
        let result: NetworkResult<RaceResultDto> = await APIHandler.get(APIService.getResults())
        switch result {
        case .success(let dto):
            let raceResult = dto.mrData.raceTable.races.map { dtoRace -> RaceResultModel in
                let raceResultData = dtoRace.results.map { dtoResult in
                    
                    let resultTime: RaceResultTimeModel?
                    if let millis = dtoResult.time?.millis, let time = dtoResult.time?.time {
                        resultTime = RaceResultTimeModel(millis: millis, time: time)
                    } else {
                        resultTime = nil
                    }
                    
                    return RaceResultDataModel(position: dtoResult.position,
                                               points: dtoResult.points,
                                               driver: createDriverModel(from: dtoResult.driver),
                                               constructor: createConstructorModel(from: dtoResult.constructor),
                                               grid: dtoResult.grid,
                                               laps: dtoResult.laps,
                                               status: dtoResult.status,
                                               time: resultTime)
                }
                
                let raceDate = combineDate(date: dtoRace.date, time: dtoRace.time)
                
                return RaceResultModel(round: dtoRace.round,
                                       raceName: dtoRace.raceName,
                                       circuit: createCircuitModel(from: dtoRace.circuit),
                                       date: raceDate,
                                       results: raceResultData)
            }
            return .success(raceResult)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getQualifyingResult() async -> NetworkResult<[QualifyingResultModel]> {
        let result: NetworkResult<QualifyingResultDto> = await APIHandler.get(APIService.getQualifyingResult())
        switch result {
        case .success(let dto):
            let qualifyingResult = dto.mrData.raceTable.races.map { dtoQuali -> QualifyingResultModel in
                let qualifyingResultData = dtoQuali.qualifyingResults.map { dtoResult in
                    QualifyingResultDataModel(position: dtoResult.position, 
                                              number: dtoResult.position,
                                              driver: createDriverModel(from: dtoResult.driver),
                                              constructor: createConstructorModel(from: dtoResult.constructor),
                                              q1: dtoResult.q1,
                                              q2: dtoResult.q2,
                                              q3: dtoResult.q3)
                }
                
                let qualiDate = combineDate(date: dtoQuali.date, time: dtoQuali.time)
                
                return QualifyingResultModel(round: dtoQuali.round,
                                             raceName: dtoQuali.raceName,
                                             circuit: createCircuitModel(from: dtoQuali.circuit),
                                             date: qualiDate,
                                             qualifyingResults: qualifyingResultData)
            }
            
            return .success(qualifyingResult)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getSprintResult() async -> NetworkResult<[SprintResultModel]> {
        let result: NetworkResult<SprintResultDto> = await APIHandler.get(APIService.getSprintResult())
        switch result {
        case .success(let dto):
            let sprintResult = dto.mrData.raceTable.races.map { dtoSprint -> SprintResultModel in
                
                let sprintResultData = dtoSprint.sprintResults.map { dtoResult in
                    
                    let resultTime: SprintResultTimeModel?
                    if let millis = dtoResult.time?.millis, let time = dtoResult.time?.time {
                        resultTime = SprintResultTimeModel(millis: millis, time: time)
                    } else {
                        resultTime = nil
                    }
                    
                    return SprintResultDataModel(position: dtoResult.position,
                                                 points: dtoResult.points,
                                                 driver: createDriverModel(from: dtoResult.driver),
                                                 constructor: createConstructorModel(from: dtoResult.constructor),
                                                 grid: dtoResult.grid,
                                                 laps: dtoResult.laps,
                                                 status: dtoResult.status,
                                                 time: resultTime)
                }
                
                let sprintDate = combineDate(date: dtoSprint.date, time: dtoSprint.time)
                
                return SprintResultModel(round: dtoSprint.round,
                                         raceName: dtoSprint.raceName,
                                         circuit: createCircuitModel(from: dtoSprint.circuit),
                                         date: sprintDate,
                                         sprintResults: sprintResultData)
            }
            
            return .success(sprintResult)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getStandings() async -> NetworkResult<([DriverStandingModel], [ConstructorStandingModel])> {
        async let driverStandingsResult: NetworkResult<[DriverStandingModel]> = getDriverStandings()
        async let constructorStandingsResult: NetworkResult<[ConstructorStandingModel]> = getConstructorStandings()

        do {
            let driverStandings = try await driverStandingsResult.get()
            let constructorStandings = try await constructorStandingsResult.get()

            // Tworzenie mapowania driverCode do constructorID
            var driverCodeMap = [String: [String]]() // constructorID: [driverCodes]
            for driverStanding in driverStandings {
                let constructorID = driverStanding.constructors.constructorID
                let driverCode = driverStanding.driver.code
                driverCodeMap[constructorID, default: []].append(driverCode)
            }

            // Aktualizacja ConstructorStandings z kodami kierowców
            let updatedConstructorStandings = constructorStandings.map { standing in
                var updatedStanding = standing
                let driverCodes = driverCodeMap[standing.constructor.constructorID] ?? []
                updatedStanding.constructor.driver1code = driverCodes.first
                updatedStanding.constructor.driver2code = driverCodes.dropFirst().first
                return updatedStanding
            }

            return .success((driverStandings, updatedConstructorStandings))
        } catch {
            return .failure(error as! NetworkError)
        }
    }

    
    func getDriverStandings() async -> NetworkResult<[DriverStandingModel]> {
        let result: NetworkResult<DriverStandingDto> = await APIHandler.get(APIService.getStandings(standingsType: .driverStandings))
        switch result {
        case .success(let dto):
            let driverStandings = dto.mrData.standingsTable.standingsLists.map {
                $0.driverStandings.map { standings in
                    DriverStandingModel(position: standings.position,
                                        points: standings.points,
                                        driver: createDriverModel(from: standings.driver),
                                        constructors: createConstructorModel(from: standings.constructors.first!)) /// dto return array with only one constructor per driver
                }
            }.flatMap { $0 }
            return .success(driverStandings)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getConstructorStandings() async -> NetworkResult<[ConstructorStandingModel]> {
        let result: NetworkResult<ConstructorStandingDto> = await APIHandler.get(APIService.getStandings(standingsType: .constructorStandings))
        switch result {
        case .success(let dto):
            let constructorStandings = dto.mrData.standingsTable.standingsLists.map {
                $0.constructorStandings.map { standings in
                    ConstructorStandingModel(position: standings.position,
                                             points: standings.points,
                                             constructor: createConstructorModel(from: standings.constructor))
                }
            }.flatMap { $0 }
            return .success(constructorStandings)
        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: Helping methods

extension Repository {
    private func combineDate(date dateString: String, time timeString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd' 'H:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        let combinedString = "\(dateString) \(timeString)"
        return dateFormatter.date(from: combinedString)!
    }
    
    private func createDriverModel(from driverDto: DriverDto) -> DriverModel {
        return DriverModel(driverID: driverDto.driverID,
                           code: driverDto.code,
                           name: driverDto.givenName,
                           surname: driverDto.familyName,
                           nationality: driverDto.nationality)
    }

    private func createConstructorModel(from constructorDto: ConstructorDto) -> ConstructorModel {
        return ConstructorModel(constructorID: constructorDto.constructorID,
                                name: constructorDto.name,
                                nationality: constructorDto.nationality,
                                driver1code: nil,
                                driver2code: nil
        )
    }

    private func createCircuitModel(from circuitDto: CircuitDto) -> CircuitModel {
        return CircuitModel(circuitID: circuitDto.circuitID,
                            circuitName: circuitDto.circuitName,
                            location: createLocationModel(from: circuitDto.location))
    }

    private func createLocationModel(from locationDto: LocationDto) -> LocationModel {
        return LocationModel(locality: locationDto.locality, country: locationDto.country)
    }
}
