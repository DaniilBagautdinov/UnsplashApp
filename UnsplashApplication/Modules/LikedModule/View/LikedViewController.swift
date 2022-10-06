import UIKit
import UnsplashPhotoPicker

class LikedViewController: UIViewController {
    
    // MARK: - UI Components
    
    private var tableView: UITableView = UITableView()
    
    // MARK: - Properties
    
    private var photos = [UnsplashPhoto]()
    
    // MARK: - View Model
    
    var viewModel: LikedViewModelProtocol! {
        didSet {
            self.viewModel.photosDidChange = { [weak self] viewModel in
                self?.photos = viewModel.photos
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
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
        title = "Liked"
        addViews()
        configureTableView()
        DispatchQueue.main.async { [weak self] in
            self?.configureLayouts()
        }
    }
    
    private func addViews() {
        view.addSubview(tableView)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LikedTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 60
    }
    
    private func configureLayouts() {
        let topAnchor = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leftAnchor = tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightAnchor = tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        let bottomAnchor = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([topAnchor,leftAnchor,rightAnchor,bottomAnchor])
    }
}

// MARK: - UITableViewDataSource

extension LikedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LikedTableViewCell else { return UITableViewCell()}
        cell.configureView(photo: photos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showDetail(photo: photos[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
