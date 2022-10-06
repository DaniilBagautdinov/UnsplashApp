import UIKit
import UnsplashPhotoPicker
import Alamofire

class LikedTableViewCell: UITableViewCell {
    
    // MARK: - UI Components

    private var photoImageView: UIImageView = UIImageView()
    private var authorLabel: UILabel = UILabel()
    
    // MARK: - Functions
    
    func configureView(photo: UnsplashPhoto) {
        addViews()
        configurePhotoImageView()
        configureAuthorLabel()
        DispatchQueue.main.async { [weak self] in
            self?.configureLayouts()
        }
        downloadPhoto(photo: photo)
    }
    
    // MARK: - Private Functions
    
    private func addViews() {
        addSubview(photoImageView)
        addSubview(authorLabel)
    }
    
    private func configurePhotoImageView() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
    }
    
    private func configureAuthorLabel() {
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayouts() {
        configurePhotoImageViewLayouts()
        configurwAuthorLabelLayouts()
    }
    
    private func configurePhotoImageViewLayouts() {
        let topAnchor = photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3)
        let leftAnchor = photoImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        let bottomAnchor = photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2)
        let height = photoImageView.heightAnchor.constraint(equalToConstant: 55)
        let width = photoImageView.widthAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([topAnchor,leftAnchor,bottomAnchor,height,width])
    }
    
    private func configurwAuthorLabelLayouts() {
        let topAnchor = authorLabel.topAnchor.constraint(equalTo: self.topAnchor)
        let leftAnchor = authorLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 8)
        let rightAnchor = authorLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        let bottomAnchor = authorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([topAnchor,leftAnchor,rightAnchor,bottomAnchor])
    }
    
    private func downloadPhoto(photo: UnsplashPhoto) {
        guard let photoUrl = photo.urls[.regular] else { return }
        
        AF.request(photoUrl).response { [weak self] response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                self?.photoImageView.image = image
                self?.authorLabel.text = photo.user.name
            case .failure(let error):
                print(error)
            }
        }
    }
}
