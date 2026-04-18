import XCTest

@testable import ImageFeed

final class ProfileViewPresenterTests: XCTestCase {
    var presenter: ProfileViewPresenter!
    var mockView: MockProfileViewController!

    override func setUp() {
        super.setUp()
        mockView = MockProfileViewController()
        presenter = ProfileViewPresenter()
        presenter.view = mockView
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        super.tearDown()
    }

    func test_confirmProfileLogout_callsLogout_andSwitchesToSplash() {
        presenter.confirmProfileLogout()

        XCTAssertTrue(mockView.switchToSplashCalled)
    }
}
