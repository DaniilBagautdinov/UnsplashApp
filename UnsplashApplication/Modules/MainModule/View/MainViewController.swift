import UIKit
import UnsplashPhotoPicker

class MainViewController: UIViewController {
    
    // MARK: - UI Components
    
    private var searchTextField: UITextField = UITextField()
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Properties
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    private let itemsPerRow: CGFloat = 1
    
    private var photos = [UnsplashPhoto]()
    
    // MARK: - View Model
    
    var viewModel: MainViewModelProtocol! {
        didSet {
            self.viewModel.photosDidChange = { [weak self] viewModel in
                guard let photos = viewModel.photos else { return }
                self?.photos = photos
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
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
        title = "Main"
        addViews()
        configureTextField()
        configureCollectionView()
        DispatchQueue.main.async { [weak self] in
            self?.configureLayouts()
        }
    }
    
    private func addViews() {
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
    }
    
    private func configureTextField() {
        searchTextField.placeholder = "Search"
        searchTextField.borderStyle = .roundedRect
        searchTextField.delegate = self
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayouts() {
        configureTextFieldsLayouts()
        configureCollectionViewLayouts()
    }
    
    private func configureTextFieldsLayouts() {
        let topAnchor = searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leftAnchor = searchTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        let rightAnchor = searchTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        NSLayoutConstraint.activate([topAnchor,leftAnchor,rightAnchor])
    }
    
    private func configureCollectionViewLayouts() {
        let topAnchor = collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor)
        let leftAnchor = collectionView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightAnchor = collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        let bottomAnchor = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([topAnchor,leftAnchor,rightAnchor,bottomAnchor])
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell()}
        cell.configureView(photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showDetail(photo: photos[indexPath.row])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = searchTextField.text else { return false }
        
        viewModel.showUnsplashPhotoPicker(query: text)
        return true
    }
}

// MARK: - UnsplashPhotoPickerDelegate

extension MainViewController: UnsplashPhotoPickerDelegate {
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        viewModel.addNewPhotos(newPhotos: photos)
    }

    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        print("Unsplash photo picker did cancel")
    }
}
