import Foundation
import Alamofire
import UnsplashPhotoPicker

protocol MainServiceProtocol {
    var downloadIsFinished: (([UnsplashPhoto]) -> Void)? { get set }
    
    func getRandomPhotos()
}

class MainService: MainServiceProtocol {
    
    // MARK: - Properties
    
    static var shared: MainService = MainService()

    var downloadIsFinished: (([UnsplashPhoto]) -> Void)?
    private let constants: Constants = Constants.shared
    private let decoder: JSONDecoder = JSONDecoder()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Functions
    
    func getRandomPhotos() {
        guard let url = URL(string: constants.getRandomPhotosUrl()) else { return }
        AF.request(url).response { [weak self] response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                guard let photos = try? self?.decoder.decode([UnsplashPhoto].self, from: data) else { return }
                self?.downloadIsFinished?(photos)
            case .failure(let error):
                print(error)
            }
        }
    }
}
