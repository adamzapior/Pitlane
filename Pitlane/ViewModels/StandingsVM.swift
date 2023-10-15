import Foundation

protocol StandingsVMDelegate: AnyObject {
    func standingsDidUpdate(_ viewModel: StandingsVM, standings: [DriverStandingModel])
    func driverStandingsDidUpdate(_ viewModel: StandingsVM, driverStandings: [DriverStandingModel])
    func standingsDidFailToUpdate(_ viewModel: StandingsVM, error: Error)
}

class StandingsVM {
    var repository = Repository()
    weak var delegate: StandingsVMDelegate?

    var standings: [StandingsListModel] = []

//    {
//        didSet {
//            delegate?.standingsDidUpdate(self, standings: standings)
//
//            driverStandings = extractDriverStandings(from: standings)
//        }
//    }

    var driverStandings: [DriverStandingModel] = []

    var driversTest: [DriverStandingModel] = [DriverStandingModel(
        position: "1",
        positionText: "1st",
        points: "100",
        wins: "5",
        driver: DriverModel(
            driverID: "hamiltonL44",
            permanentNumber: "44",
            code: "HAM",
            url: "https://www.formula1.com/drivers/lewis-hamilton/",
            givenName: "Lewis",
            familyName: "Hamilton",
            dateOfBirth: "1985-01-07",
            nationality: "British"
        ),
        constructors: [
            ConstructorModel(
                constructorID: "mercedes",
                url: "https://www.formula1.com/teams/Mercedes-AMG-Petronas-Formula-One-Team/",
                name: "Mercedes-AMG Petronas",
                nationality: "German"
            ),
            ConstructorModel(
                constructorID: "redbull",
                url: "https://www.formula1.com/teams/Red-Bull-Racing/",
                name: "Red Bull Racing",
                nationality: "Austrian"
            )
        ]
    )]

//    {
//        didSet {
//            delegate?.driverStandingsDidUpdate(self, driverStandings: driverStandings)
//        }
//    }

    func fetchStandings() async {
        switch await repository.getStandindigs() {
        case let .success(fetchedStandings):
            driverStandings = fetchedStandings
            delegate?.standingsDidUpdate(self, standings: driverStandings)
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

    func updateStandings(with newStandings: [DriverStandingModel]) {
        driverStandings = newStandings
//        driverStandings = extractDriverStandings(from: newStandings)

        // Możesz także tutaj powiadomić delegata o aktualizacji jeśli jest to potrzebne
//        delegate?.standingsDidUpdate(self, standings: standings)
    }

//    private func extractDriverStandings(from standingsList: [StandingsModel])
//        -> [DriverStandingModel]
//    {
//        var allDriverStandings: [DriverStandingModel] = []
//        for standing in standingsList {
//            for standingList in standing.standingsLists {
//                if let driverStandings = standingList.driverStandings {
//                    allDriverStandings.append(contentsOf: driverStandings)
//                }
//            }
//        }
//        return allDriverStandings
//    }
}
