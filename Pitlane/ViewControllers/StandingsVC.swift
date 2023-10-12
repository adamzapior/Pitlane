import Foundation
import UIKit

class StandingsVC: UIViewController {

    var vm = StandingsVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        vm.delegate = self

        Task {
            await vm.fetchStandings()
        }

        view.backgroundColor = .systemBackground
        title = "Standings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

extension StandingsVC: StandingsVMDelegate {

    func standingsDidUpdate(_: StandingsVM, standings _: [StandingsModel]) {
        print("Data loaded")

        for standing in vm.standings {
            print(standing.season)
        }

        for driverStanding in vm.driverStandings {
            print(driverStanding.driver.familyName)
        }
    }

    func standingsDidFailToUpdate(_: StandingsVM, error _: Error) {
        print("Failed to load")
    }

    func driverStandingsDidUpdate(_: StandingsVM, driverStandings _: [DriverStandingModel]) {
//        for driverStanding in viewModel.driverStandings {
//            print(driverStanding.driver.familyName)
//        }
    }
}
