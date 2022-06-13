import Foundation

class ReloadableDataSource<View: AnyObject & ReloadableView, Cell, Section: Hashable, Item>: NSObject, Reloadable {
    weak var reloadableView: View?
    var automaticReloadData = true
    
    // MARK: Aliases
    
    typealias ItemProvider = (_ view: View, _ indexPath: IndexPath, _ item: Item) -> Cell?
    
    // MARK: - Data
    
    private(set) var sections: [Section] = []
    
    private(set) var data: [Section: [Item]] = [:] {
        didSet {
            guard automaticReloadData else { return }
            reloadableView?.reloadData()
        }
    }
    
    // MARK: - Providers
    
    var itemProvider: ItemProvider?
    
    // MARK: - Initializer
    
    init(view: View, itemProvider: ItemProvider? = nil) {
        super.init()
        self.reloadableView = view
        self.itemProvider = itemProvider
    }
    
    // MARK: - Data management
    
    /// Adds a section to the data source
    /// - Parameter section: The section to be added to the data source
    /// - Note: If the section is already present, the data source does not change
    func add(section: Section) {
        if !sections.contains(section) {
            sections.append(section)
            data[section] = []
        }
    }
    
    /// Add items to the given section
    /// - Parameters:
    ///   - items: The items to be added to the section
    ///   - section: A type that conforms to `Hashable` to represents a section
    /// - Note: If the section is not part of the data source, it will also add the section
    func add(items: [Item], to section: Section) {
        add(section: section)
        var currentItems = data[section, default: []]
        currentItems.append(contentsOf: items)
        data[section] = currentItems
    }
    
    /// Set  items to the given section
    /// - Parameters:
    ///   - items: The items to be added to the section
    ///   - section: A type that conforms to `Hashable` to represents a section
    /// - Note: If the section is not part of the data source, it will also add the section
    func set(items: [Item], to section: Section) {
        add(section: section)
        data[section] = items
    }
    
    /// Clear items to the given section
    /// - Parameters:
    ///   - section: A type that conforms to `Hashable` to represents a section
    /// - Note: If the section is not part of the data source, it will also add the section
    func clear(_ section: Section) {
        add(section: section)
        data[section] = []
    }
    
    /// Updates the given section with the contents of the `items` parameter
    /// - Parameters:
    ///   - items: Items to replace the contents of the section
    ///   - section: The section to be updated
    /// - Note: If the section doesn't exists the data source does not change
    public func update(items: [Item], from section: Section) {
        if sections.contains(section),
           let sectionInt = section as? Int {
            automaticReloadData = false
            data[section] = items
            reloadableView?.reloadSections([sectionInt])
        } else {
            set(items: items, to: section)
        }
        automaticReloadData = true
    }
    
    /// - Parameter indexPath: The item `IndexPath`
    /// - Returns: Returns the item at the given `IndexPath` if the item exists, otherwise returns `nil`
    func item(at indexPath: IndexPath) -> Item? {
        guard let section = sections[safe: indexPath.section],
              data.contains(where: { $0.key == section }),
              let itens = data[section],
              let item = itens[safe: indexPath.row] else {
                  return nil
              }
        return item
    }
}
