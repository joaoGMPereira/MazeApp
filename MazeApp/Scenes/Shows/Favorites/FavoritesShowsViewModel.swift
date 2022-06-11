protocol FavoritesShowsViewModeling: ShowsViewModeling {
    func changeSort()
    func reset()
}

enum FavoritesSort {
    case ascending
    case descending
    case none
    
    func toggle() -> FavoritesSort {
        self == .ascending ? .descending : .ascending
    }
}

final class FavoritesShowsViewModel {
    typealias Dependencies = HasStorageable & HasMainQueue
    private let dependencies: Dependencies
    private let coordinator: ShowsCoordinating
    weak var displayer: FavoritesShowsDisplaying?
    
    private var isLoading = false
    private var shows = [ShowItem]()
    private var sort = FavoritesSort.none
    
    private var filteredShow: [ShowItem] {
        switch sort {
        case .ascending:
            return shows.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        case .descending:
            return shows.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending
            }
        case .none:
            return shows
        }
    }
    
    init(coordinator: ShowsCoordinating,
         dependencies: Dependencies) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }
}

// MARK: - ShowsViewModeling
extension FavoritesShowsViewModel: FavoritesShowsViewModeling {
    func loadShows() {
        displayer?.displayLoad()
        getShows { [weak self] in
            self?.displayer?.hideLoad()
        }
    }
    
    func changeSort() {
        self.sort = sort.toggle()
        self.displayer?.displayShows(filteredShow)
        self.displayer?.showReset()
    }
    
    func reset() {
        self.sort = .none
        self.displayer?.displayShows(filteredShow)
        self.displayer?.hideReset()
    }
    
    func getShows(completion: @escaping () -> Void) {
        dependencies.storage.getAll(identifiable: "favorite_") { [weak self] (showItems: [ShowItem]) in
            guard let self = self else { return }
            self.shows = showItems
            self.displayer?.displayShows(self.filteredShow)
            completion()
        }
    }
}
