import Foundation

class Constants {
    
    static var shared: Constants = Constants()
    
    let accessKey: String = "DOgps1xpjcWfbPZ0HlsYAzFDmkYu_YaOce3-UitzMns"
    let secretKey: String = "DOgps1xpjcWfbPZ0HlsYAzFDmkYu_YaOce3-UitzMns"
    
    let heart: String = "heart"
    let trash: String = "trash"
    let heartFill: String = "heart.fill"
    
    let likePhotoAlert: (String, String) = ("Like photo", "Are you sure you want to like the photo?")
    let deletePhotoAlert: (String, String) = ("Delete photo", "Are you sure you want to delete the photo?")
    let answers: (String, String) = ("No", "Yes")
    
    private init() {}
    
    func getRandomPhotosUrl() -> String {
        "https://api.unsplash.com/photos/random/?client_id=\(accessKey)&count=10"
    }
    
    func getSomeUserUrl(id: String) -> String {
        "https://api.unsplash.com/photos/\(id)?client_id=\(accessKey)"
    }
    
    func getAuthorName(username: String) -> String {
        "Author name: \(username)"
    }
    
    func getDownloadsCount(downloadsCount: String) -> String {
        "Downloads count: \(downloadsCount)"
    }
    
    func getDate(date: String) -> String {
        "Date of publication: \(date)"
    }
    
    func getLocation(location: String) -> String {
        location == "" ? "Location: The author hid the location" : "Location: \(location)"
    }
}
