import Foundation

protocol StandingsVMDelegate: AnyObject {
    func driverStandingDidUpdate(_ viewModel: StandingsVM, standing: [DriverStandingModel])
    func constructorStandingDidUpdate(_ viewModel: StandingsVM, standing: [ConstructorStandingModel])
    func standingsDidFailToUpdate(_ viewModel: StandingsVM, error: Error)
}

class StandingsVM {
    var repository = Repository()
    weak var delegate: StandingsVMDelegate?

    var driverStanding: [DriverStandingModel] = []
    var constructorStanding: [ConstructorStandingModel] = []

    var highestPoints: Int?
    var constuctorHighestPoints: Int?

    
    func updateHighestPoints() {
            highestPoints = driverStanding.compactMap { Int($0.points) }.max()
        }
    
    func updateConstuctorHighestPoints() {
        constuctorHighestPoints = constructorStanding.compactMap { Int($0.points) }.max()
    }
    
    init() {
       
    }
    
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
                updateHighestPoints()
                updateConstuctorHighestPoints()

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
