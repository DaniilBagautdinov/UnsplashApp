import UIKit

enum TabBarPage {
    
    // MARK: - Cases
    
    case main
    case liked
    
    // MARK: - Init
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .main
        case 1:
            self = .liked
        default:
            return nil
        }
    }

    // MARK: - Functions
    
    func pageImageValue() -> UIImage? {
        switch self {
        case .main:
            return UIImage(systemName: "house")
        case .liked:
            return UIImage(systemName: "heart")
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .main:
            return "Home"
        case .liked:
            return "Liked"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .main:
            return 0
        case .liked:
            return 1
        }
    }
}
