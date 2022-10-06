import UIKit
import UnsplashPhotoPicker
import Alamofire

class MainCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private var photoImageView: UIImageView = UIImageView()
    private var authorLabel: UILabel = UILabel()
    
    // MARK: - Properties
    
    private static var cache: URLCache = {
        let memoryCapacity = 50 * 1024 * 1024
        let diskCapacity = 100 * 1024 * 1024
        let diskPath = "unsplash"
        
        return URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity,
            directory: URL(fileURLWithPath: diskPath, isDirectory: true)
        )
    }()
    
    // MARK: - Functions
    
    func configureView(_ photo: UnsplashPhoto) {
        addViews()
        configureImageView()
        configureAuthorLabel()
        DispatchQueue.main.async { [weak self] in
            self?.configureLayouts()
        }
        downloadPhoto(photo)
    }
    
    // MARK: - Private Functions
    
    private func addViews() {
        addSubview(photoImageView)
    }
    
    private func configureImageView() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.addSubview(authorLabel)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
    }
    
    private func configureAuthorLabel() {
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.textColor = .white
    }
    
    private func configureLayouts() {
        configureImageViewLayouts()
        configureAuthorLabelLayouts()
    }
    
    private func configureImageViewLayouts() {
        let topAnchor = photoImageView.topAnchor.constraint(equalTo: self.topAnchor)
        let leftAnchor = photoImageView.leftAnchor.constraint(equalTo: self.leftAnchor)
        let rightAnchor = photoImageView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let bottomAnchor = photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([topAnchor,leftAnchor,rightAnchor,bottomAnchor])
    }
    
    private func configureAuthorLabelLayouts() {
        let leftAnchor = authorLabel.leftAnchor.constraint(equalTo: photoImageView.leftAnchor, constant: 8)
        let bottomAnchor = authorLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8)
        NSLayoutConstraint.activate([leftAnchor,bottomAnchor])
    }

    private func downloadPhoto(_ photo: UnsplashPhoto) {
        guard let url = photo.urls[.regular] else { return }

        if let cachedResponse = MainCollectionViewCell.cache.cachedResponse(for: URLRequest(url: url)),
            let image = UIImage(data: cachedResponse.data) {
            photoImageView.image = image
            return
        }
        AF.request(url).response { [weak self] response in
            switch response.result {
            case .success(let data):
                guard let strongSelf = self else { return }
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    UIView.transition(with: strongSelf.photoImageView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                        strongSelf.photoImageView.image = image
                        strongSelf.authorLabel.text = photo.user.name
                    }, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
