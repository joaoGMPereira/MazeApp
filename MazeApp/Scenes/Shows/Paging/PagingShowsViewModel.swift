import Foundation

protocol PagingShowsViewModeling: ShowsViewModeling {
    func getFilteredShows(title: String)
    func getNextShows()
}

final class PagingShowsViewModel {
    typealias Dependencies = HasApi & HasMainQueue
    private let dependencies: Dependencies
    private let coordinator: ShowsCoordinating
    weak var displayer: PagingShowsDisplaying?
    
    private var nextPage: Int = .zero
    private var currentPage: Int = .zero
    private var isLoading = false
    private var shows = [Show]()
    private var filteredShows = [Show]()
    private var search = String()
    
    var isSearching: Bool {
        return search.isNotEmpty
    }
    
    init(coordinator: ShowsCoordinating,
         dependencies: Dependencies) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }
}

// MARK: - ShowsViewModeling
extension PagingShowsViewModel: PagingShowsViewModeling {
    func loadShows() {
        reset()
        displayer?.displayLoad()
        getShows { [weak self] in
            self?.displayer?.hideLoad()
            if self?.shows.isEmpty == true {
                self?.displayer?.displayEmptyView()
            }
        }
    }
    
    func getFilteredShows(title: String) {
        search = title
        if isSearching {
            displayer?.displayLoad()
            getFilteredShows { [weak self] in
                guard let self = self else { return }
                self.displayer?.hideLoad()
            }
            return
        }
        changeShows(shows)
    }
    
    func getNextShows() {
        if !isLoading && !isSearching {
            isLoading = true
            nextPage = currentPage + 1
            displayer?.displayNextPageLoad()
            getShows { [weak self] in
                guard let self = self else { return }
                self.currentPage = self.nextPage
                self.isLoading = false
                self.displayer?.hideNextPageLoad()
            }
        }
    }
    
    func didTap(at indexPath: IndexPath) {
        if isSearching,
           let filteredShow = filteredShows[safe: indexPath.row] {
            coordinator.goToSerie(filteredShow)
            return
        }
        if let show = shows[safe: indexPath.row] {
            coordinator.goToSerie(show)
            return
        }
    }
}

private extension PagingShowsViewModel {
    func getFilteredShows(completion: @escaping () -> Void) {
        dependencies
            .api
            .execute(
                endpoint: ShowsEndpoint.list(page: nextPage, search: search)
            ) { [weak self] (result: Result<Success<SearchShows>, ApiError>) in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    self.filteredShows = success.model.map{ $0.show }
                    self.showFilteredShows()
                case .failure:
                    self.displayer?.displayEmptyView()
                }
                completion()
            }
    }
    
    func getShows(completion: @escaping () -> Void) {
        dependencies
            .api
            .execute(
                endpoint: ShowsEndpoint.list(page: nextPage, search: search)
            ) { [weak self] (result: Result<Success<Shows>, ApiError>) in
                guard let self = self else { return }
                self.handleResponse(result, completion: completion)
            }
    }
    
    func handleResponse(_ result: Result<Success<Shows>, ApiError>, completion: @escaping () -> Void) {
        switch result {
        case .success(let success):
            self.shows.append(contentsOf: success.model)
            self.displayer?.displayShows(self.shows)
        case .failure:
            self.backToPreviousPage()
        }
        completion()
    }
    
    func showFilteredShows() {
        if filteredShows.isNotEmpty {
            changeShows(filteredShows)
        } else {
            displayer?.displayFilteredEmptyView()
        }
    }
    
    func changeShows(_ shows: Shows) {
        displayer?.clearShows()
        displayer?.displayShows(shows)
    }
    
    func reset() {
        nextPage = .zero
        currentPage = .zero
        search = String()
    }
    
    func backToPreviousPage() {
        nextPage = currentPage
    }
}
