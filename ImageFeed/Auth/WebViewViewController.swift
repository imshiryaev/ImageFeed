import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    weak var delegate: WebViewViewControllerDelegate?
    
    private var webView = WKWebView()
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView()
        view.addSubview(progress)
        progress.progressTintColor = .background
        
        progress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progress.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progress.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadAuthView()
        
        webView.navigationDelegate = self
        
        updateProgress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil
        )
        updateProgress()
    }
    
    private func setupUI() {
        setupWebView()
        _ = progressView
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.backgroundColor = .white
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}


extension WebViewViewController: WKNavigationDelegate {
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
            Log(.error, "Invalid OAuth token URL string: \(Constants.unsplashAuthorizeURLString)")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            Log(.error, "Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func fetchCode(from navigationAction: WKNavigationAction) -> String? {
        guard
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.host == "unsplash.com",
            urlComponents.path == "/oauth/authorize/native",
            let item = urlComponents.queryItems?.first(where: { $0.name == "code" })
        else {
            #if DEBUG
            Log(.debug, "No OAuth code found in navigation URL — probably a regular page load \(navigationAction.request.url?.absoluteString ?? "nil")")
            #endif
            return nil
        }
        #if DEBUG
        Log(.debug, "Successfully extracted OAuth code")
        #endif
        
        return item.value
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
