import UIKit

protocol Reloadable {
    var automaticReloadData: Bool { get set }
}

protocol ReloadableView {
    func reloadData()
}

extension UICollectionView: ReloadableView {}
