import UIKit

final class AppCoordinator: AbstractCoordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    var coordinators: [AbstractCoordinator] = []
    
    // MARK: - UIWindow
    
    private let window: UIWindow?
    
    // MARK: - Init
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    // MARK: - Start
    
    func start() {
        window?.rootViewController = navigationController
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        coordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}
