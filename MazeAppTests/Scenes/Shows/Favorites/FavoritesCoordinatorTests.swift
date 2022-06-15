import XCTest
@testable import MazeApp

class ViewControllerMock: UIViewController {
    private(set) var didPushControllerCount = 0
    private(set) var viewControllerPushed = UIViewController()
    
    override func pushViewController(_ viewController: UIViewController, hidesBottomBar: Bool = true, animated: Bool = true) {
        didPushControllerCount += 1
        viewControllerPushed = viewController
        super.pushViewController(viewControllerPushed, animated: animated)
    }
}

class ShowsCoordinatorTests: XCTestCase {
    
    func testInit_ShouldNotCallLoadShows() {
        let (_, viewController, tabController) = makeSut()
        XCTAssertTrue(viewController.didPushControllerCount == .zero)
        XCTAssertTrue(tabController.messages.isEmpty)
    }
    
    
    func testSelectShowTab_ShouldTabBeChanged() {
        let (sut, _, tabController) = makeSut()
        sut.goToShows()
        XCTAssertEqual(tabController.messages, [.setSelected(.zero)])
    }
    
    func testGoToSeries_ShouldPushViewController() {
        let (sut, viewController, _) = makeSut()
        sut.goToSerie(.showFixture())
        XCTAssertNotNil(viewController.viewControllerPushed)
        XCTAssertEqual(viewController.didPushControllerCount, 1)
    }
   
    func makeSut() -> (sut: ShowsCoordinator,
                       viewController: ViewControllerMock,
                       tabController: TabControllingSpy) {
        let tabController = TabControllingSpy()
        let sut = ShowsCoordinator(dependencies: DependencyContainerMock(tabController))
        let viewControllerMock = ViewControllerMock()
        sut.viewController = viewControllerMock
        return (sut, viewControllerMock, tabController)
    }
    
}
