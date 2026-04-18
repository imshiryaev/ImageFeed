import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(view: WebViewViewControllerProtocol? = nil, authHelper: AuthHelperProtocol) {
        self.view = view
        self.authHelper = authHelper
    }

    func viewDidLoad() {
        didUpdateProgressValue(0)
        
        let request = authHelper.makeRequest()
        view?.load(request: request)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)

        let isHidden = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(isHidden)
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
