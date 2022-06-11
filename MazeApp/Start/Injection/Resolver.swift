final class AppResolver: FeatureResolving {
    static let shared: FeatureResolving = AppResolver()
    private init() { /* Use shared instance */ }
    @Injected var parentResolver: DependencyResolving
}
