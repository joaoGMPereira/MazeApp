protocol DependencyStoring {
    func get<T>(_ metaType: T.Type) -> T?
    func add<T>(_ factory: @escaping DependencyFactory, for metaType: T.Type)
}
