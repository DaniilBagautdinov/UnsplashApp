import UIKit
import UnsplashPhotoPicker

class MainCoordinator: AbstractCoordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    var coordinators: [AbstractCoordinator] = []
    
    private let constants: Constants = Constants.shared
    
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
        let mainViewModel = MainViewModel(mainService: MainService.shared, photoService: PhotoService.shared)
        let mainView = MainViewController()
        mainView.viewModel = mainViewModel
        mainViewModel.setRandomPhotos()
        
        mainViewModel.nextRoute = { route in
            switch route {
            case .unsplashPhotoPicker(let query):
                let configuration = UnsplashPhotoPickerConfiguration(
                    accessKey: self.constants.accessKey,
                    secretKey: self.constants.secretKey,
                    query: query,
                    allowsMultipleSelection: true
                )
                let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
                unsplashPhotoPicker.photoPickerDelegate = mainView

                self.navigationController.present(unsplashPhotoPicker, animated: true)
                
            case .detailScreen(let photo):
                let detailViewModel = DetailViewModel(detailService: DetailService.shared, photoService: PhotoService.shared)
                let detailView = DetailViewController()
                detailView.viewModel = detailViewModel
                detailView.isMainScreen = true
                detailView.photo = photo
                detailViewModel.getDetailInfo(photo: photo)
                
                detailViewModel.dismissDetailViewControllerToMain = { [weak self] in
                    self?.navigationController.popViewController(animated: true)
                }
                
                self.navigationController.show(detailView, sender: self)
            }
        }
        
        navigationController.show(mainView, sender: self)
    }
}
