import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate, LocalStorageApi {
    private let userDefaults = UserDefaults.standard
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 1. First, we have obtained the FlutterViewController controller in order to access binaryMessenger.
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

        LocalStorageApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: self)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func addFavorite(id: String) {
        toggleFavorite(id, isFavorite: true)
    }
    
    func getFavorites() -> [FavoriteProduct] {
        let favoriteIds = getFavoriteIds()
        let favorites = favoriteIds.map { id in 
            return FavoriteProduct(id: id)
        }
        return favorites
    }

    func isFavorite(id: String) -> Bool {
        return getFavoriteIds().contains(id)
    }

    func removeFavorite(id: String) {
        toggleFavorite(id, isFavorite: false)
    }
    
    private func getFavoriteIds() -> [String] {
        if let favorites = userDefaults.array(forKey: "favorites") as? [String] {
            return favorites
        }
        return []
    }
    
    private func toggleFavorite(_ id: String, isFavorite: Bool) {
        var currentFavorites = getFavoriteIds()
        if isFavorite {
            currentFavorites.append(id)
        } else {
            currentFavorites.removeAll { $0 == id }
        }
        
        userDefaults.set(currentFavorites, forKey: "favorites")
    }
}
