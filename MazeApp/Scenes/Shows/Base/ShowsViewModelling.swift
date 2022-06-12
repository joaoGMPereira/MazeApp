import Foundation

public protocol ShowsViewModeling: AnyObject {
    func loadShows()
    func didTap(at index: IndexPath)
}
