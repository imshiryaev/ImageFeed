@testable import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var view: (any ImageFeed.WebViewViewControllerProtocol)?
    var isViewDidLoad = false

    func viewDidLoad() {
        isViewDidLoad = true
    }

    func didUpdateProgressValue(_ newValue: Double) {
        
    }

    func code(from url: URL) -> String? {
        nil
    }

}
