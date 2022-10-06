import UIKit

protocol AbstractCoordinator: AnyObject {
    
    var navigationController: UINavigationController { get }
    var coordinators: [AbstractCoordinator] { get set }
    
    func start()
}

extension AbstractCoordinator {
    
    public func removeChildCoordinator(_ coordinator: AbstractCoordinator) {
        
        guard let index = coordinators.firstIndex(where: { $0 === coordinator }) else { return }
        coordinators.remove(at: index)
    }
}
