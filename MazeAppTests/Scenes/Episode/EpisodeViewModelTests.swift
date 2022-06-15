import XCTest
@testable import MazeApp

class FavoritesShowsDisplayerSpy: FavoritesShowsDisplaying {
    enum Messages: AutoEquatable {
        case displayEmptyView
        case displayLoad
        case hideLoad
        case displayShows(_ shows: [Show])
        case showReset
        case hideReset
    }
    
    private(set) var messages: [Messages] = []
    func displayEmptyView() {
        messages.append(.displayEmptyView)
    }
    
    func displayLoad() {
        messages.append(.displayLoad)
    }
    
    func hideLoad() {
        messages.append(.hideLoad)
    }
    
    func displayShows(_ shows: [Show]) {
        messages.append(.displayShows(shows))
    }
    
    func showReset() {
        messages.append(.showReset)
    }
    
    func hideReset() {
        messages.append(.hideReset)
    }
    
}

class FavoritesViewModelTests: XCTestCase {
    
    func testInit_ShouldNotCallLoadShows() {
        let (_, display, _) = makeSut()
        XCTAssertTrue(display.messages.isEmpty)
    }
    
    
    func testLoadShows_WhenHaveFavorites_ShouldDisplayShows() {
        let shows = [
            Show.showFixture(name: "Arrow", id: 1),
            Show.showFixture(name: "Testing", id: 2),
            Show.showFixture(name: "How Testing", id: 3)
        ]
        let (_, displayer, _) = sutWithShows(shows)
        
        XCTAssertEqual(displayer.messages, [.displayLoad, .displayShows(shows), .hideLoad])
    }
    
    func testLoadShows_WhenDontHaveFavorites_ShouldDisplayEmptyView() {
        let (_, displayer, _) = sutWithShows([])
        
        XCTAssertEqual(displayer.messages, [.displayLoad, .displayEmptyView, .hideLoad])
    }
    
    func testGoToShows_ShouldChangeToShowTab() {
        let (sut, _, coordinator) = makeSut()
        sut.goToShows()
        XCTAssertEqual(coordinator.messages, [.shows])
    }
    
    func testChangeToSort_whenTapOneTime_ShouldChangeToAscending() {
        let shows = [
            Show.showFixture(name: "Arrow", id: 1),
            Show.showFixture(name: "Testing", id: 2),
            Show.showFixture(name: "How Testing", id: 3)
        ]
        let sortedShows = shows.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
        let (sut, displayer, _) = sutWithShows(shows)
        sut.changeSort()
        XCTAssertEqual(displayer.messages, [.displayLoad, .displayShows(shows), .hideLoad, .displayShows(sortedShows), .showReset])
        XCTAssertEqual(sut.sort, .ascending)
    }
    
    func testChangeToSort_whenTapOneTwoTimes_ShouldChangeToAscending() {
        let shows = [
            Show.showFixture(name: "Arrow", id: 1),
            Show.showFixture(name: "Testing", id: 2),
            Show.showFixture(name: "How Testing", id: 3)
        ]
        let sortedAscendingShows = shows.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
        let sortedDecendingShows = shows.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending
        }
        let (sut, displayer, _) = sutWithShows(shows)
        sut.changeSort()
        sut.changeSort()
        XCTAssertEqual(displayer.messages, [.displayLoad, .displayShows(shows), .hideLoad, .displayShows(sortedAscendingShows), .showReset, .displayShows(sortedDecendingShows), .showReset])
        XCTAssertEqual(sut.sort, .descending)
    }
    
    func testResetSort_whenIsSorted_ShouldRemoveSort() {
        let shows = [
            Show.showFixture(name: "Arrow", id: 1),
            Show.showFixture(name: "Testing", id: 2),
            Show.showFixture(name: "How Testing", id: 3)
        ]
        let sortedShows = shows.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
        let (sut, displayer, _) = sutWithShows(shows)
        sut.changeSort()
        sut.reset()
        XCTAssertEqual(displayer.messages, [.displayLoad, .displayShows(shows), .hideLoad, .displayShows(sortedShows), .showReset, .displayShows(shows), .hideReset])
        XCTAssertEqual(sut.sort, .none)
    }
    
    func testFavoriteSelection_WhenHaveShowsSetup_ShouldGoToSerie() {
        let shows = [
            Show.showFixture(name: "Arrow", id: 1),
            Show.showFixture(name: "Testing", id: 2),
            Show.showFixture(name: "How Testing", id: 3)
        ]
        let (sut, _, coordinator) = sutWithShows(shows)
        sut.didTap(at: .init(item: .zero, section: .zero))
        
        XCTAssertEqual(coordinator.messages, [.serie(shows[0])])
    }
    
    func testFavoriteSelection_WhenDontHaveShowsSetup_ShouldNotGoToSerie() {
        let (sut, _, coordinator) = makeSut()
        sut.didTap(at: .init(item: .zero, section: .zero))
        
        XCTAssertEqual(coordinator.messages, [])
    }
    
    func makeSut() -> (sut: FavoritesShowsViewModel, displayer: FavoritesShowsDisplayerSpy, coordinator: ShowsCoordinatorSpy) {
        let coordinator = ShowsCoordinatorSpy()
        let sut = FavoritesShowsViewModel(coordinator: coordinator, dependencies: DependencyContainerMock())
        let displayer = FavoritesShowsDisplayerSpy()
        sut.displayer = displayer
        return (sut, displayer, coordinator)
    }
    
    // MARK: Helpers
    func sutWithShows(_ shows: [Show]) -> (sut: FavoritesShowsViewModel, displayer: FavoritesShowsDisplayerSpy, coordinator: ShowsCoordinatorSpy) {
        let coordinator = ShowsCoordinatorSpy()
        let dependencies = DependencyContainerMock()
        setShows(dependencies, shows)
        let sut = FavoritesShowsViewModel(coordinator: coordinator, dependencies: dependencies)
        let displayer = FavoritesShowsDisplayerSpy()
        sut.displayer = displayer
        sut.loadShows()
        return (sut, displayer, coordinator)
    }
    
    func setShows(_ dependencies: DependencyContainerMock, _ shows: [Show]) {
        shows.forEach { show in
            dependencies.storage.set(show, key: StorageKey.favorite(show.id))
        }
    }
    
}

extension Show: AutoEquatable {}

extension Show {
    static func showFixture(name: String? = nil, id: Int? = nil) -> Show {
        .init(id: id ?? .anyValue,
              name: name ?? .anyValue,
              genres: [.anyValue],
              schedule:
                .init(time: .anyValue,
                      days: [.anyValue]),
              rating: .init(average: 5),
              image: .init(medium: .anyValue,
                           original: .anyValue),
              runtime: .anyValue,
              averageRuntime: .anyValue,
              summary: .anyValue)
    }
}
