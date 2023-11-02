//
//  MainVM.swift
//  Pitlane
//
//  Created by Adam Zapiór on 22/10/2023.

import Foundation

protocol ScheduleVMDelegate: AnyObject {
    func scheduleDidUpdate(_ viewModel: ScheduleVM, schedule: [RaceModel])
}

class ScheduleVM {
    var repository = Repository()
    weak var delegate: ScheduleVMDelegate?

    lazy var raceSchedule: [RaceModel] = []

    lazy var futureRaces: [RaceModel] = []
    lazy var pastRaces: [RaceModel] = []

    func fetchSchedule() async {
        let result = await repository.getSchedule()
        switch result {
        case .success(let schedule):
            raceSchedule = schedule
            futureRaces = filterFutureSchedule(schedule: raceSchedule)
            pastRaces = filterPastSchedule(schedule: raceSchedule)
            delegate?.scheduleDidUpdate(self, schedule: raceSchedule)
        case .failure(let error):
            print("Error fetching race schedule: \(error)")
        }
    }

    private func filterFutureSchedule(schedule: [RaceModel]) -> [RaceModel] {
        let today = Date()
        return raceSchedule.filter { race in
            guard let raceDate = raceDate(from: race.date) else { return false }
            return raceDate >= today
        }
    }

    private func filterPastSchedule(schedule: [RaceModel]) -> [RaceModel] {
        let today = Date()
        let pastRaces = raceSchedule.filter { race in
            guard let raceDate = raceDate(from: race.date) else { return false }
            return raceDate < today
        }
        return pastRaces.sorted(by: { firstRace, secondRace in
            guard let firstDate = raceDate(from: firstRace.date),
                  let secondDate = raceDate(from: secondRace.date) else { return false }
            return firstDate < secondDate
        }).reversed()
    }

    private func raceDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
}
