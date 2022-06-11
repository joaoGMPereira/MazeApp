import Foundation

protocol PagingShowsViewModeling: ShowsViewModeling {
    func getFilteredShows(title: String)
    func getNextShows()
    func didTap(at index: IndexPath)
}

final class PagingShowsViewModel {
    typealias Dependencies = HasApi & HasMainQueue
    private let dependencies: Dependencies
    private let coordinator: ShowsCoordinating
    weak var displayer: PagingShowsDisplaying?
    
    private var nextPage: Int = .zero
    private var currentPage: Int = .zero
    private var isLoading = false
    private var shows = [ShowItemResponse]()
    private var filteredShows = [ShowItemResponse]()
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
        }
    }
    
    func getFilteredShows(title: String) {
        search = title
        if isSearching {
            displayer?.displayLoad()
            getFilteredShows { [weak self] in
                guard let self = self else { return }
                self.isLoading = false
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
        guard let show = shows[safe: indexPath.row] else {
            //error feedback
            return
        }
        coordinator.goToShow(show)
    }
}

private extension PagingShowsViewModel {
    func getFilteredShows(completion: @escaping () -> Void) {
        dependencies
            .api
            .execute(
                endpoint: ShowsEndpoint.list(page: nextPage, search: search)
            ) { [weak self] (result: Result<Success<SearchShowItemResponses>, ApiError>) in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    self.filteredShows = success.model.map{ $0.show }
                    self.changeShows(self.filteredShows)
                case .failure(let error):
                    self.handleResponse(.failure(error),
                                        completion: completion)
                }
                
            }
    }
    
    func getShows(completion: @escaping () -> Void) {
        dependencies
            .api
            .execute(
                endpoint: ShowsEndpoint.list(page: nextPage, search: search)
            ) { [weak self] (result: Result<Success<ShowItemResponses>, ApiError>) in
                guard let self = self else { return }
                self.handleResponse(result, completion: completion)
            }
    }
    
    func handleResponse(_ result: Result<Success<ShowItemResponses>, ApiError>, completion: @escaping () -> Void) {
        switch result {
        case .success(let success):
            self.shows.append(contentsOf: success.model)
            self.displayer?.displayShows(self.items(from: self.shows))
        case .failure:
            self.backToPreviousPage()
            self.displayer?.displayError()
        }
        completion()
    }
    
    func items(from shows: ShowItemResponses) -> [ShowItem] {
        shows.map {
            .init(id: "\($0.id)",
                  imageUrl: $0.image?.medium,
                  name: $0.name,
                  average: $0.rating.average)
        }
    }
    
    func changeShows(_ shows: ShowItemResponses) {
        if filteredShows.isNotEmpty {
            displayer?.clearShows()
            displayer?.displayShows(self.items(from: shows))
        }
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
