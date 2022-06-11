import Foundation

protocol SerieCellViewModeling: AnyObject {
    func getFavoriteState() -> Bool
    func tapFavorite()
}

final class SerieCellViewModel {
    typealias Dependencies = HasStorageable
    private let dependencies: Dependencies
    weak var displayer: SerieCelling?
    
    private let showItem: SerieItem
    
    init(dependencies: Dependencies, showItem: SerieItem) {
        self.dependencies = dependencies
        self.showItem = showItem
    }
}

// MARK: - SeriesViewModeling
extension SerieCellViewModel: SerieCellViewModeling {
    func getFavoriteState() -> Bool {
        let favorite: SerieItem? = dependencies.storage.get(key: StorageKey.favorite(showItem.id))
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
