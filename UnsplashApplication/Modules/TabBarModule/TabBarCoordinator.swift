import UIKit

final class TabBarCoordinator: NSObject, AbstractCoordinator {
    
    // MARK: - Properties
    
    public var navigationController: UINavigationController
    public var coordinators: [AbstractCoordinator] = []
    public var tabBarController: UITabBarController
    
    public var tabBarFlowCompletionHandler: (() -> Void)?
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
    }
    
    // MARK: - Start
    
    func start() {
        let pages: [TabBarPage] = [.main, .liked].sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        let controllers: [UINavigationController] = pages.map({ getTabController(page: $0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    // MARK: - Private Functions
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        navigationController.navigationItem.hidesBackButton = true
        navigationController.show(tabBarController, sender: self)
        
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.main.pageOrderNumber()
        tabBarController.tabBar.isTranslucent = false
        navigationController.viewControllers = [tabBarController]
        navigationController.isNavigationBarHidden = true
    }
    
    private func getTabController(page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(), image: page.pageImageValue(), tag: page.pageOrderNumber())
        navigationController.isNavigationBarHidden = false
        switch page {
        case .main:
            showMain(navigationController: navigationController)
        case .liked:
            showLiked(navigationController: navigationController)
        }
        return navigationController
    }
    
    private func showMain(navigationController: UINavigationController) {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        coordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
    
    private func showLiked(navigationController: UINavigationController) {
        let likedCoordinator = LikedCoordinator(navigationController: navigationController)
        coordinators.append(likedCoordinator)
        likedCoordinator.start()
    }
    
    private func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }
    
    private func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    private func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
}

