//
//  Respository.swift
//  Pitlane
//
//  Created by Adam Zapiór on 23/09/2023.
//

import Alamofire
import Foundation

class Repository {
    func getSchedule() async -> NetworkResult<[RaceModel]> {
        let result: NetworkResult<F1ApiModel> = await APIHandler.get(APIService.getSchedule())
        switch result {
        case .success(let f1ApiModel):
            guard let raceTable = f1ApiModel.f1Data.raceTable?.races else {
                return .failure(NetworkError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            return .success(raceTable)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    // MARK:  -  START
    
    
    func getSchedule1() async -> NetworkResult<[ScheduleModel]> {
        let result: NetworkResult<ScheduleDto> = await APIHandler.get(APIService.getSchedule())
        switch result {
        case .success(let dto):
            let schedule = dto.mrData.raceTable.races.compactMap { dto -> ScheduleModel? in
                
                /// If any date component is nil, race will not be in the schedule array.
                guard let firstPracticeDate = combineDate(date: dto.firstPractice.date, time: dto.firstPractice.time),
                      let secondPracticeDate = combineDate(date: dto.secondPractice.date, time: dto.secondPractice.time),
                      let qualifyingDate = combineDate(date: dto.qualifying.date, time: dto.qualifying.time),
                      let raceDate = combineDate(date: dto.date, time: dto.time)
                else {
                    return nil
                }
                
                /// Optional practice data
                var thirdPracticeDate: Date? = nil
                if let thirdPractice = dto.thirdPractice {
                    thirdPracticeDate = combineDate(date: thirdPractice.date, time: thirdPractice.time)
                }
                
                var sprintDate: Date? = nil
                if let sprint = dto.sprint {
                    sprintDate = combineDate(date: sprint.date, time: sprint.time)
                }
                
                return ScheduleModel(round: dto.round,
                                     raceName: dto.raceName,
                                     circuit: CircuitModel1(circuitID: dto.circuit.circuitID,
                                                            circuitName: dto.circuit.circuitName,
                                                            location: LocationModel1(locality: dto.circuit.location.locality, country: dto.circuit.location.country)),
                                     date: raceDate,
                                     firstPractice: PracticeDataModel1(date: firstPracticeDate),
                                     secondPractice: PracticeDataModel1(date: secondPracticeDate),
                                     thirdPractice: thirdPracticeDate != nil ? PracticeDataModel1(date: thirdPracticeDate!) : nil,
                                     qualifying: PracticeDataModel1(date: qualifyingDate),
                                     sprint: sprintDate != nil ? PracticeDataModel1(date: sprintDate!) : nil)
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
                                       date: raceDate!,
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
                    QualifyingResultDataModel(number: dtoResult.position,
                                              position: dtoResult.position,
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
                                             date: qualiDate!,
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
                                         date: sprintDate!,
                                         sprintResults: sprintResultData)
            }
            
            return .success(sprintResult)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getDriverStandings() async -> NetworkResult<[DriverStandingModel1]> {
        let result: NetworkResult<DriverStandingDto> = await APIHandler.get(APIService.getStandings(year: "2023", standingsType: .driverStandings))
        switch result {
        case .success(let dto):
            let driverStandings = dto.mrData.standingsTable.standingsLists.map {
                $0.driverStandings.map { standings in
                    return DriverStandingModel1(position: standings.position, points: standings.points, driver: createDriverModel(from: standings.driver), constructors: createConstructorModel(from: standings.constructors.first!)) // dto return array with only one constructor per driver
                }
            }.flatMap { $0 }
            return .success(driverStandings)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getConstructorStandings() async -> NetworkResult<[ConstructorStandingModel1]> {
        let result: NetworkResult<ConstructorStandingDto> = await APIHandler.get(APIService.getStandings(year: "2023", standingsType: .constructorStandings))
        switch result {
        case .success(let dto):
            let constructorStandings = dto.mrData.standingsTable.standingsLists.map {
                $0.constructorStandings.map { standings in
                    ConstructorStandingModel1(position: standings.position, points: standings.points, constructor: createConstructorModel(from: standings.constructor))
                }
            }.flatMap { $0 }
            return .success(constructorStandings)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    // MARK:  -  END
    
    func getResults() async -> NetworkResult<[RaceModel]> {
        let result: NetworkResult<F1ApiModel> = await APIHandler.get(APIService.getResults())
        switch result {
        case .success(let f1ApiModel):
            guard let raceResult = f1ApiModel.f1Data.raceTable?.races else {
                return .failure(NetworkError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            return .success(raceResult)
        case .failure(let error):
            return .failure(error)
        }
    }
    
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

// MARK: Parsing methods

extension Repository {
    private func combineDate(date dateString: String, time timeString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd' 'H:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        let combinedString = "\(dateString) \(timeString)"
        return dateFormatter.date(from: combinedString)
    }
    
    private func createDriverModel(from driverDto: DriverDto) -> DriverModel1 {
        return DriverModel1(driverID: driverDto.driverID,
                            name: driverDto.givenName,
                            surname: driverDto.familyName,
                            nationality: driverDto.nationality)
    }

    private func createConstructorModel(from constructorDto: ConstructorDto) -> ConstructorModel1 {
        return ConstructorModel1(constructorID: constructorDto.constructorID,
                                 name: constructorDto.name,
                                 nationality: constructorDto.nationality)
    }

    private func createCircuitModel(from circuitDto: CircuitDto) -> CircuitModel1 {
        return CircuitModel1(circuitID: circuitDto.circuitID,
                             circuitName: circuitDto.circuitName,
                             location: createLocationModel(from: circuitDto.location))
    }

    private func createLocationModel(from locationDto: LocationDto) -> LocationModel1 {
        return LocationModel1(locality: locationDto.locality, country: locationDto.country)
    }
}
