import Foundation
import Alamofire
import UnsplashPhotoPicker
import SwiftyJSON

protocol DetailServiceProtocol {
    var downloadIsFinished: ((DetailInfo) -> Void)? { get set }
    
    func getDetailInfo(photo: UnsplashPhoto)
}

class DetailService: DetailServiceProtocol {
    
    // MARK: - Properties
    
    static var shared: DetailService = DetailService()

    var downloadIsFinished: ((DetailInfo) -> Void)?
    private let constants: Constants = Constants.shared
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Functions
    
    func getDetailInfo(photo: UnsplashPhoto) {
        guard let url = URL(string: constants.getSomeUserUrl(id: photo.identifier)) else { return }
        AF.request(url).response { [weak self] response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                let json = JSON(data)
                guard let photoUrl = photo.urls[.regular] else { return }
                
                AF.request(photoUrl).response { [weak self] response in
                    switch response.result {
                    case .success(let data):
                        guard let data = data else { return }
                        guard let image = UIImage(data: data) else { return }
                        self?.downloadIsFinished?(DetailInfo(photoImage: image, date: json["created_at"].stringValue, location: json["location"]["country"].stringValue))
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
