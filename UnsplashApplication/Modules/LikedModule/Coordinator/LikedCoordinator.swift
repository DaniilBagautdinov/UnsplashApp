import UIKit

class LikedCoordinator: AbstractCoordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    var coordinators: [AbstractCoordinator] = []
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Start
    
    func start() {
        assemble()
    }
    
    // MARK: - Private Functions
    
    private func assemble() {
        let likedViewModel = LikedViewModel(photoService: PhotoService.shared)
        let likedView = LikedViewController()
        likedView.viewModel = likedViewModel
        
        likedViewModel.nextRoute = { photo in
            let detailViewModel = DetailViewModel(detailService: DetailService.shared, photoService: PhotoService.shared)
            let detailView = DetailViewController()
            detailView.viewModel = detailViewModel
            detailView.isMainScreen = false
            detailView.photo = photo
            detailViewModel.getDetailInfo(photo: photo)
            
            detailViewModel.dismissDetailViewControllerToLiked = { [weak self] in
                self?.navigationController.popViewController(animated: true)
            }
            
            self.navigationController.show(detailView, sender: self)
        }
        
        navigationController.show(likedView, sender: self)
    }
}
