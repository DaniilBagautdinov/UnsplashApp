import Foundation
import UnsplashPhotoPicker

protocol PhotoServiceProtocol {
    var likeIsTapped: ((UnsplashPhoto) -> Void)? { get set }
    var deletePhotoFromMain: ((UnsplashPhoto) -> Void)? { get set }
    var deletePhotoFromLiked: ((UnsplashPhoto) -> Void)? { get set }
}

class PhotoService: PhotoServiceProtocol {
    
    // MARK: - Properties
    
    static var shared: PhotoService = PhotoService()
    
    var likeIsTapped: ((UnsplashPhoto) -> Void)?
    var deletePhotoFromMain: ((UnsplashPhoto) -> Void)?
    var deletePhotoFromLiked: ((UnsplashPhoto) -> Void)?
    
    // MARK: - Init
    
    private init() {}
}
