@testable import ImageFeed
import Foundation

final class WebViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: (any ImageFeed.WebViewPresenterProtocol)?
    var isLoadRequest = false
    
    func load(request: URLRequest) {
        isLoadRequest = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
    
    
}
