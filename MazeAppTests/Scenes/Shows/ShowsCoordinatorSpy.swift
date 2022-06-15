@testable import MazeApp

class ShowsCoordinatorSpy: ShowsCoordinating {
    enum Messages: AutoEquatable {
        case shows
        case serie(_ show: Show)
    }
    
    private(set) var messages: [Messages] = []
    
    func goToShows() {
        messages.append(.shows)
    }
    
    func goToSerie(_ show: Show) {
        messages.append(.serie(show))
    }
}
