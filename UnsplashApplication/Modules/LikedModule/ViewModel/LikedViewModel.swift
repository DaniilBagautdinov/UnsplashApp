import Foundation
import UnsplashPhotoPicker

protocol LikedViewModelProtocol {
    var photos: [UnsplashPhoto] { get set }
    
    var photosDidChange: ((LikedViewModelProtocol) -> Void)? { get set }
    var nextRoute: ((UnsplashPhoto) -> Void)? { get set }
    
    func showDetail(photo: UnsplashPhoto)
}

class LikedViewModel: LikedViewModelProtocol {
    
    // MARK: - Properties
    
    var photos: [UnsplashPhoto] = [] {
        didSet {
            self.photosDidChange?(self)
        }
    }
    
    var photosDidChange: ((LikedViewModelProtocol) -> Void)?
    var nextRoute: ((UnsplashPhoto) -> Void)?
    
    private var photoService: PhotoServiceProtocol
    
    // MARK: - Init
    
    init(photoService: PhotoServiceProtocol) {
        self.photoService = photoService
        
        self.photoService.likeIsTapped = { [weak self] photo in
            self?.photos.append(photo)
        }
        
        self.photoService.deletePhotoFromLiked = { [weak self] photo in
            self?.photos.removeAll(where: {$0.identifier == photo.identifier})
        }
    }
    
    // MARK: - Functions
    
    func showDetail(photo: UnsplashPhoto) {
        nextRoute?(photo)
    }
}
