import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

protocol WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSObjectProtocol?

    private var webView = WKWebView()
    private var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = .background
        progress.translatesAutoresizingMaskIntoConstraints = false

        return progress
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpObservation()
        presenter?.viewDidLoad()
    }

    private func setUpObservation() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
            options: [],
             changeHandler: { [weak self] _,_  in
                guard let self else { return }
                self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
            }
        )
    }

    func load(request: URLRequest) {
        webView.load(request)
    }

    private func setupUI() {
        view.backgroundColor = .white
        setupWebView()
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])

    }

    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    private func setupWebView() {
        view.addSubview(webView)
        webView.backgroundColor = .white
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.accessibilityIdentifier = "UnsplashWebView"

        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}

extension WebViewViewController: WKNavigationDelegate {
    private func fetchCode(from navigationAction: WKNavigationAction) -> String? {
        guard let url = navigationAction.request.url else { return nil }
        return presenter?.code(from: url)
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
    ) {
        guard let code = fetchCode(from: navigationAction) else {
            decisionHandler(.allow)
            return
        }
        delegate?.webViewViewController(self, didAuthenticateWithCode: code)
        decisionHandler(.cancel)
    }
}
