import Foundation

protocol PagingShowsViewModeling: ShowsViewModeling {
    func getFilteredShows(title: String)
    func getNextShows()
    func didTap(at index: IndexPath)
    var isSearching: Bool { get }
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
        displayer?.displayLoad()
        getShows { [weak self] in
            self?.displayer?.hideLoad()
        }
    }
    
    func getFilteredShows(title: String) {
        if !isLoading {
            isLoading = true
            resetPagination()
            displayer?.displayNextPageLoad()
            getShows { [weak self] in
                guard let self = self else { return }
                self.isLoading = false
                self.displayer?.hideNextPageLoad()
            }
        }
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
    func getShows(completion: @escaping () -> Void) {
        dependencies
            .api
            .execute(
                endpoint: ShowsEndpoint.list(page: nextPage, search: search)
            ) { [weak self] (result: Result<Success<ShowItemResponses>, ApiError>) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        self.shows.append(contentsOf: success.model)
                        self.displayer?.displayShows(self.items())
                    case .failure(let failure):
                        print(failure)
                        self.backToPreviousPage()
                        self.displayer?.displayError()
                    }
                    completion()
                }
            }
    }
    
    func items() -> [ShowItem] {
        shows.map {
            .init(id: "\($0.id)",
                  imageUrl: $0.image?.medium,
                  name: $0.name,
                  average: $0.rating.average)
        }
    }
    
    func resetPagination() {
        nextPage = .zero
        currentPage = .zero
    }
    func backToPreviousPage() {
        nextPage = currentPage
    }
}
