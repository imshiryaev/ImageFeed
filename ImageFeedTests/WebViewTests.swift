import XCTest

@testable import ImageFeed

@MainActor
class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        viewController.viewDidLoad()

        XCTAssertTrue(presenter.isViewDidLoad)
    }
    
    func testPresenterCallsLoadRequest() {
        let viewController = WebViewViewControllerSpy()
        let helper = AuthHelperMock()
        let presenter = WebViewPresenter(authHelper: helper)
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.loadRequestCalled)
        
    }
    
    func testProgressVisibleWhenLessThenOne() {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        

        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        let helper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: helper)
        
        let progress: Float = 1
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        let helper = AuthHelper()
        let apiConfig: ApiConfiguration = .standart
        guard let url = helper.makeRequest().url?.absoluteString else { return }
        
        XCTAssertTrue(url.contains(apiConfig.accessKey))
        XCTAssertTrue(url.contains(apiConfig.redirectURI))
        XCTAssertTrue(url.contains("code"))
        XCTAssertTrue(url.contains(apiConfig.accessScope))
        XCTAssertTrue(url.contains(apiConfig.unsplashAuthorizeURLString))
    }

    func testCodeFromURL() {
        let helper = AuthHelper()
        
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponents?.queryItems = [
            URLQueryItem(name: "code", value: "test code")
        ]
        
        guard let url = urlComponents?.url else { return }
        
        XCTAssertEqual(helper.code(from: url), "test code")
    }
}
