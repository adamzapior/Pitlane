import Foundation

protocol StandingsVMDelegate: AnyObject {
//    func standingsDidUpdate(_ viewModel: StandingsVM, standings: [DriverStandingModel])
    func driverStandingDidUpdate(_ viewModel: StandingsVM, standing: [DriverStandingModel])
    func constructorStandingDidUpdate(_ viewModel: StandingsVM, standing: [ConstructorStandingModel])
    func standingsDidFailToUpdate(_ viewModel: StandingsVM, error: Error)
}

class StandingsVM {
    var repository = Repository()
    weak var delegate: StandingsVMDelegate?

    var driverStanding: [DriverStandingModel] = []
    var constructorStanding: [ConstructorStandingModel] = []

    func fetchStandings() async {
        do {
            async let driverStandingsResult: NetworkResult<[DriverStandingModel]> = repository.getDriverStanding()
            async let constructorStandingsResult: NetworkResult<[ConstructorStandingModel]> = repository.getConstructorStanding()

            let driverResult = await driverStandingsResult
            let constructorResult = await constructorStandingsResult

            switch (driverResult, constructorResult) {
            case let (.success(fetchedDriverStandings), .success(fetchedConstructorStandings)):
                driverStanding = fetchedDriverStandings
                constructorStanding = fetchedConstructorStandings

                delegate?.driverStandingDidUpdate(self, standing: driverStanding)
                delegate?.constructorStandingDidUpdate(self, standing: constructorStanding)
                
            // In this case i would send same information to delegate in ViewController about failed API Call
            case let (.failure(driverError), _):
                print("Error fetching driver standings")
                delegate?.standingsDidFailToUpdate(self, error: driverError)

            case let (_, .failure(constructorError)):
                print("Error fetching constructor standings")
                delegate?.standingsDidFailToUpdate(self, error: constructorError)
            }
        }
    }
}
