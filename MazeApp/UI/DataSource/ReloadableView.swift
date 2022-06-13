import UIKit

protocol Reloadable {
    var automaticReloadData: Bool { get set }
}

protocol ReloadableView {
    func reloadData()
    func reloadSections(_ sections: IndexSet)
}

extension UICollectionView: ReloadableView {}
