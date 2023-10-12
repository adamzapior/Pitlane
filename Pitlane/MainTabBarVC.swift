import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        // MARK: View Setup

        let vc1 = UINavigationController(rootViewController: MainVC())
        let vc2 = UINavigationController(rootViewController: ResultsVC())
        let vc3 = UINavigationController(rootViewController: StandingsVC())

        // MARK: Tab Bar Icons

        // kur
        // testtttasdsdsadsadasdasdsad
        // safasfafs

        vc1.tabBarItem.image = UIImage(systemName: "heart")
        vc2.tabBarItem.image = UIImage(systemName: "house")

        vc3.tabBarItem.image = UIImage(systemName: "house")

        // MARK: Tab Bar Title

        vc1.title = "Home"
        vc2.title = "Results"
        vc3.title = "Standings"

        // MARK: Tab Bar Color

        tabBar.tintColor = .label
        tabBar.isTranslucent = false
        tabBar.tintColor = .red

        let appearance = UITabBarAppearance()
//        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal:
//        0, vertical: -1)
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        // MARK: - Set up in the VIEW CONTROLLER

        setViewControllers([vc1, vc2, vc3], animated: true)
    }

}
