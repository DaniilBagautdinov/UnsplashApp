import Foundation
import UnsplashPhotoPicker

protocol DetailViewModelProtocol {
    var detailInfo: DetailInfo? { get set }
    
    var detailInfoDidChange: ((DetailViewModelProtocol) -> Void)? { get set }
    var dismissDetailViewControllerToMain: (() -> Void)? { get set }
    var dismissDetailViewControllerToLiked: (() -> Void)? { get set }
    
    func getDetailInfo(photo: UnsplashPhoto)
    func buttonMainScreenAction(photo: UnsplashPhoto)
    func buttonLikedScreenAction(photo: UnsplashPhoto)
}

class DetailViewModel: DetailViewModelProtocol {
    
    // MARK: - Properties
    
    var detailInfo: DetailInfo? {
        didSet {
            self.detailInfoDidChange?(self)
        }
    }
    
    var detailInfoDidChange: ((DetailViewModelProtocol) -> Void)?
    var dismissDetailViewControllerToMain: (() -> Void)?
    var dismissDetailViewControllerToLiked: (() -> Void)?
    
    private var detailService: DetailServiceProtocol
    private var photoService: PhotoService
    
    // MARK: - Init
    
    init(detailService: DetailServiceProtocol, photoService: PhotoService) {
        self.detailService = detailService
        self.photoService = photoService
        
        self.detailService.downloadIsFinished = { [weak self] detailInfo in
            self?.detailInfo = detailInfo
        }
    }
    
    // MARK: - Functions
    
    func getDetailInfo(photo: UnsplashPhoto) {
        detailService.getDetailInfo(photo: photo)
    }
    
    func buttonMainScreenAction(photo: UnsplashPhoto) {
        photoService.likeIsTapped?(photo)
        photoService.deletePhotoFromMain?(photo)
        dismissDetailViewControllerToMain?()
    }
    
    func buttonLikedScreenAction(photo: UnsplashPhoto) {
        photoService.deletePhotoFromLiked?(photo)
        dismissDetailViewControllerToLiked?()
    }
}
