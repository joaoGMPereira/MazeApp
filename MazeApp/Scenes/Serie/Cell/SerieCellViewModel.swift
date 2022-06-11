import Foundation

protocol SerieCellViewModeling: AnyObject {
}

final class SerieCellViewModel {
    typealias Dependencies = HasStorageable
    private let dependencies: Dependencies
    weak var displayer: SerieCelling?
    
    private let show: Show
    init(dependencies: Dependencies, show: Show) {
        self.dependencies = dependencies
        self.show = show
    }
}

// MARK: - SeriesViewModeling
extension SerieCellViewModel: SerieCellViewModeling {

}
