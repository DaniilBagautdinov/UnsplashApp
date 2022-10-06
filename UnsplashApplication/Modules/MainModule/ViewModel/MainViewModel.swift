import Foundation
import UnsplashPhotoPicker

enum NextRoute {
    case unsplashPhotoPicker(query: String)
    case detailScreen(photo: UnsplashPhoto)
}

protocol MainViewModelProtocol {
    var photos: [UnsplashPhoto]? { get set }
    
    var photosDidChange: ((MainViewModelProtocol) -> Void)? { get set }
    
    var nextRoute: ((NextRoute) -> Void)? { get set }
    
    func showUnsplashPhotoPicker(query: String)
    func showDetail(photo: UnsplashPhoto)
    func setRandomPhotos()
    func addNewPhotos(newPhotos: [UnsplashPhoto])
}

class MainViewModel: MainViewModelProtocol {
    
    // MARK: - Properties
    
    var photos: [UnsplashPhoto]? {
        didSet {
            self.photosDidChange?(self)
        }
    }
    
    var photosDidChange: ((MainViewModelProtocol) -> Void)?
    
    var nextRoute: ((NextRoute) -> Void)?
    
    private var mainService: MainServiceProtocol
    private var photoService: PhotoServiceProtocol
    
    // MARK: - Init
    
    init(mainService: MainServiceProtocol, photoService: PhotoServiceProtocol) {
        self.mainService = mainService
        self.photoService = photoService
        
        self.mainService.downloadIsFinished = { [weak self] photos in
            self?.photos = photos
        }
        
        self.photoService.deletePhotoFromMain = { [weak self] photo in
            self?.photos?.removeAll(where: {$0.identifier == photo.identifier})
        }
    }
    
    // MARK: - Functions
    
    func showUnsplashPhotoPicker(query: String) {
        nextRoute?(.unsplashPhotoPicker(query: query))
    }
    
    func showDetail(photo: UnsplashPhoto) {
        nextRoute?(.detailScreen(photo: photo))
    }
    
    func setRandomPhotos() {
        mainService.getRandomPhotos()
    }
    
    func addNewPhotos(newPhotos: [UnsplashPhoto]) {
        guard let photos = photos else { return }
        self.photos = photos + newPhotos
    }
}
