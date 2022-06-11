import Foundation

protocol ShowCellViewModeling: AnyObject {
    func getFavoriteState() -> Bool
    func tapFavorite()
}

final class ShowCellViewModel {
    typealias Dependencies = HasStorageable
    private let dependencies: Dependencies
    weak var displayer: ShowCelling?
    
    private let showItem: Show
    
    init(dependencies: Dependencies, showItem: Show) {
        self.dependencies = dependencies
        self.showItem = showItem
    }
}

// MARK: - ShowsViewModeling
extension ShowCellViewModel: ShowCellViewModeling {
    func getFavoriteState() -> Bool {
        let favorite: Show? = dependencies.storage.get(key: StorageKey.favorite(showItem.id))
        return favorite != nil
    }
    
    func tapFavorite() {
        var isFavorite = getFavoriteState()
        isFavorite = !isFavorite
        
        if isFavorite {
            dependencies.storage.set(showItem, key: StorageKey.favorite(showItem.id))
        } else {
            dependencies.storage.clearValue(key: StorageKey.favorite(showItem.id))
        }
        
        isFavorite ? displayer?.displayFavorited() : displayer?.displayNotFavorite()
    }
}
