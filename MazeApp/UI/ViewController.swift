import UIKit

protocol ViewControllerReloadable {
    func reload()
}

extension ViewControllerReloadable {
    func reload() {}
}

open class ViewController<ViewModel, V: UIView>: UIViewController, ViewConfiguration {
    let viewModel: ViewModel
    var rootView = V()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        #if DEBUG
        print("NavigationDebug – " + String(describing: type(of: self)))
        #endif
        buildLayout()
    }

    override open func loadView() {
        view = rootView
    }

    open func buildViewHierarchy() { }

    open func setupConstraints() { }

    open func configureViews() { }
}

extension ViewController where ViewModel == Void {
    convenience init(_ viewModel: ViewModel = ()) {
        self.init(viewModel: viewModel)
    }
}
