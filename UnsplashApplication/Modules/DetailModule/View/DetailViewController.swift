import UIKit
import UnsplashPhotoPicker

class DetailViewController: UIViewController {
    
    // MARK: - UI Components
    
    private var nameAuthorLabel: UILabel = UILabel()
    private var dateLabel: UILabel = UILabel()
    private var downloadsCountLabel: UILabel = UILabel()
    private var locationLabel: UILabel = UILabel()
    private var photoImageView: UIImageView = UIImageView()
    private var infoStackView: UIStackView = UIStackView()
    private var button: UIButton = UIButton()
    
    // MARK: - Properties
    
    var isMainScreen: Bool?
    var photo: UnsplashPhoto!
    private let constants: Constants = Constants.shared
    
    // MARK: - View Model
    
    var viewModel: DetailViewModelProtocol! {
        didSet {
            self.viewModel.detailInfoDidChange = { [weak self] viewModel in
                guard let username = self?.photo.user.name else { return }
                guard let downloadsCount = self?.photo.downloadsCount?.description else { return }
                guard let date = viewModel.detailInfo?.date else { return }
                guard let location = viewModel.detailInfo?.location else { return }
                guard let isMainScreen = self?.isMainScreen else { return }
                guard let heart = self?.constants.heart else { return }
                guard let trash = self?.constants.trash else { return }
                
                self?.nameAuthorLabel.text = self?.constants.getAuthorName(username: username)
                self?.downloadsCountLabel.text = self?.constants.getDownloadsCount(downloadsCount: downloadsCount)
                self?.dateLabel.text = self?.constants.getDate(date: date)
                self?.locationLabel.text = self?.constants.getLocation(location: location)
                self?.photoImageView.image = viewModel.detailInfo?.photoImage
                
                let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
                isMainScreen
                    ? self?.button.setImage(UIImage(systemName: heart, withConfiguration: imageConfiguration), for: .normal)
                    : self?.button.setImage(UIImage(systemName: trash, withConfiguration: imageConfiguration), for: .normal)
            }
        }
    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Private Functions
    
    private func configureView() {
        view.backgroundColor = .white
        title = "Detail"
        addViews()
        configureInfoStackView()
        configurePhotoImageView()
        configureButton()
        DispatchQueue.main.async { [weak self] in
            self?.configureLayouts()
        }
    }
    
    private func addViews() {
        view.addSubview(infoStackView)
        view.addSubview(photoImageView)
        view.addSubview(button)
    }
    
    private func configureInfoStackView() {
        infoStackView.addArrangedSubview(nameAuthorLabel)
        infoStackView.addArrangedSubview(dateLabel)
        infoStackView.addArrangedSubview(downloadsCountLabel)
        infoStackView.addArrangedSubview(locationLabel)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.alignment = .fill
        infoStackView.distribution = .fillEqually
        infoStackView.spacing = 8
    }
    
    private func configurePhotoImageView() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
    }
    
    private func configureButton() {
        guard let isMainScreen = isMainScreen else { return }
        isMainScreen
            ? button.addTarget(self, action: #selector(didTapButtonMainScreen), for: .touchUpInside)
            : button.addTarget(self, action: #selector(didTapButtonLikedScreen), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        configureInfoStackViewLayouts()
        configurePhotoImageViewLayouts()
        configureLikeButtonLayouts()
    }
    
    private func configureInfoStackViewLayouts() {
        let topAnchor = infoStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8)
        let leftAnchor = infoStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        let rightAnchor = infoStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        
        NSLayoutConstraint.activate([topAnchor,leftAnchor,rightAnchor])
    }
    
    private func configurePhotoImageViewLayouts() {
        let topAnchor = photoImageView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 8)
        let leftAnchor = photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        let rightAnchor = photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        let heightAnchor = photoImageView.heightAnchor.constraint(equalTo: infoStackView.widthAnchor)
        let widthAnchor = photoImageView.widthAnchor.constraint(equalTo: infoStackView.widthAnchor)
        NSLayoutConstraint.activate([topAnchor,leftAnchor,rightAnchor,heightAnchor,widthAnchor])
    }
    
    private func configureLikeButtonLayouts() {
        button.translatesAutoresizingMaskIntoConstraints = false
        let topAnchor = button.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant:16)
        let leftAnchor = button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40)
        NSLayoutConstraint.activate([topAnchor,leftAnchor])
    }
    
    // MARK: - objc
    
    @objc private func didTapButtonMainScreen() {
        let alertController = UIAlertController(title: constants.likePhotoAlert.0, message: constants.likePhotoAlert.1 , preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: constants.answers.1, style: .default, handler: { [self] _ in
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
            self.button.setImage(UIImage(systemName: constants.heartFill, withConfiguration: imageConfiguration), for: .normal)
            viewModel.buttonMainScreenAction(photo: photo)
        }))
        
        alertController.addAction(UIAlertAction(title: constants.answers.0, style: .destructive, handler: {_ in
            alertController.dismiss(animated: true)
        }))
        
        present(alertController, animated: true)
    }
    
    @objc private func didTapButtonLikedScreen() {
        let alertController = UIAlertController(title: constants.deletePhotoAlert.0, message: constants.deletePhotoAlert.1 , preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: constants.answers.1, style: .default, handler: { [self] _ in
            viewModel.buttonLikedScreenAction(photo: photo)
        }))
        
        alertController.addAction(UIAlertAction(title: constants.answers.0, style: .destructive, handler: {_ in
            alertController.dismiss(animated: true)
        }))
        
        present(alertController, animated: true)
    }
}
