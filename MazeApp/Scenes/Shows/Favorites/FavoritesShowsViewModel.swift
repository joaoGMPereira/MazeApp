protocol FavoritesShowsViewModeling: ShowsViewModeling {
    func changeSort()
    func reset()
    func goToShows()
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
    private var shows = [Show]()
    private var sort = FavoritesSort.none
    
    private var filteredShow: [Show] {
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
    func goToShows() {
        coordinator.goToShows()
    }
    
    func loadShows() {
        displayer?.displayLoad()
        getShows { [weak self] in
            self?.displayer?.hideLoad()
        }
    }
    
    func changeSort() {
        sort = sort.toggle()
        displayShows()
        displayer?.showReset()
    }
    
    func reset() {
        sort = .none
        displayShows()
        displayer?.hideReset()
    }
    
    func getShows(completion: @escaping () -> Void) {
        dependencies.storage.getAll(identifiable: "favorite_") { [weak self] (showItems: [Show]) in
            guard let self = self else { return }
            self.shows = showItems
            self.displayShows()
            completion()
        }
    }
    
    func displayShows() {
        if filteredShow.isEmpty {
            displayer?.displayEmptyView()
            return
        }
        displayer?.displayShows(filteredShow)
    }
}
