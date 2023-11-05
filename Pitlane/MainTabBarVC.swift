import UIKit

class MainTabBarVC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.UI.background

        // MARK: View Setup

        let vc1 = UINavigationController(rootViewController: ScheduleVC())
        let vc2 = UINavigationController(rootViewController: ResultsVC())
        let vc3 = UINavigationController(rootViewController: StandingsVC())

        vc1.tabBarItem.image = UIImage(systemName:
            "calendar")
        vc2.tabBarItem.image = UIImage(systemName: "flag.checkered.2.crossed")
        vc3.tabBarItem.image = UIImage(systemName: "list.number")

        vc1.title = "Home"
        vc2.title = "Results"
        vc3.tabBarItem.title = "Standings"

        tabBar.isTranslucent = true
        tabBar.tintColor = .red

        let appearance = UITabBarAppearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        setViewControllers([vc1, vc2, vc3], animated: true)
    }
}
