import UIKit

public protocol Reusable {
    static var identifier: String { get }
}

public extension Reusable {
    /// Returns the identifier based on the name of the class.
    static var identifier: String { String(describing: Self.self) }
}

extension UICollectionReusableView: Reusable { }

public extension UICollectionView {
    final func register<T: UICollectionViewCell>(cellType: T.Type) {
        self.register(cellType.self, forCellWithReuseIdentifier: cellType.identifier)
    }

    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        let dequeuedCell = self.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)

        guard let cell = dequeuedCell as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.identifier) matching type \(cellType.self)."
            )
        }

        return cell
    }

    final func register<T: UICollectionReusableView>(supplementaryViewType: T.Type, ofKind elementKind: String) {
        self.register(
            supplementaryViewType.self,
            forSupplementaryViewOfKind: elementKind,
            withReuseIdentifier: supplementaryViewType.identifier
        )
    }

    final func dequeueReusableSupplementaryView<T: UICollectionReusableView>
    (ofKind elementKind: String, for indexPath: IndexPath, viewType: T.Type = T.self) -> T {
        let view = self.dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: viewType.identifier,
            for: indexPath
        )

        guard let typedView = view as? T else {
            fatalError(
                "Failed to dequeue a supplementary view with identifier \(viewType.identifier) "
                    + "matching type \(viewType.self)."
            )
        }

        return typedView
    }
}
