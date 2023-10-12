import Foundation

protocol StandingsVMDelegate: AnyObject {
    func standingsDidUpdate(_ viewModel: StandingsVM, standings: [StandingsModel])
    func driverStandingsDidUpdate(_ viewModel: StandingsVM, driverStandings: [DriverStandingModel])
    func standingsDidFailToUpdate(_ viewModel: StandingsVM, error: Error)
}

class StandingsVM {
    var repository = Repository()
    weak var delegate: StandingsVMDelegate?

    var standings: [StandingsModel] = [] {
        didSet {
            delegate?.standingsDidUpdate(self, standings: standings)

            driverStandings = extractDriverStandings(from: standings)
        }
    }

    var driverStandings: [DriverStandingModel] = [] {
        didSet {
            delegate?.driverStandingsDidUpdate(self, driverStandings: driverStandings)
        }
    }

    func fetchStandings() async {
        switch await repository.getStandindigs() {
        case let .success(fetchedStandings):
            standings = fetchedStandings
            updateStandings(with: fetchedStandings)
        case let .failure(error):
            print("Error fetching standings: \(error)")
            delegate?.standingsDidFailToUpdate(self, error: error)
        }
    }

    func fetch() async {
        switch await repository.getStandindigs() {
        case .success: break
        case .failure: break
        }
    }

    func updateStandings(with newStandings: [StandingsModel]) {
        standings = newStandings
        driverStandings = extractDriverStandings(from: newStandings)

        // Możesz także tutaj powiadomić delegata o aktualizacji jeśli jest to potrzebne
        delegate?.standingsDidUpdate(self, standings: standings)
    }

    private func extractDriverStandings(from standingsList: [StandingsModel])
        -> [DriverStandingModel]
    {
        var allDriverStandings: [DriverStandingModel] = []
        for standing in standingsList {
            for standingList in standing.standingsLists {
                if let driverStandings = standingList.driverStandings {
                    allDriverStandings.append(contentsOf: driverStandings)
                }
            }
        }
        return allDriverStandings
    }
}
