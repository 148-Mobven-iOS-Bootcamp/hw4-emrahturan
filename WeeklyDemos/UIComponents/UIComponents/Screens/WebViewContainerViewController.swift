//
//  WebViewContainerViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 9.01.2022.
//

import UIKit
import WebKit

class WebViewContainerViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var showHTML: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if showHTML {
            configureHTMLWebView()
        } else {
            configureWebView()
            configureActivityIndicator()
        }
    }

    var urlString = "https://www.google.com"

    func configureWebView() {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)

        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
//        webView.configuration = configuration
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.isLoading),
                            options: .new,
                            context: nil)
        webView.load(urlRequest)
    }

    func configureActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.color = .red
        activityIndicator.hidesWhenStopped = true
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        if keyPath == "loading" {
            webView.isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }

    }
    
    func configureHTMLWebView() {
        webView.loadHTMLString("<html><body><p>Hello!</p></body></html>", baseURL: nil)
    }

    @IBAction func reloadButtonTapped(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        webView.goBack()
    }
    @IBAction func forwardButtonTapped(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func safariButtonTapped(_ sender: Any) {
        guard let url = URL(string: webView.url?.absoluteString ?? "") else { return }
        UIApplication.shared.open(url)
    }
}

extension WebViewContainerViewController: WKNavigationDelegate {
    //Change the font and size
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let changeFontFamilyScript = "document.getElementsByTagName(\'body\')[0].style.fontFamily = \"Impact,Charcoal,sans-serif\";" +
                                         "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"
            webView.evaluateJavaScript(changeFontFamilyScript) { (response, error) in
                
            }
        }
}

extension WebViewContainerViewController: WKUIDelegate {
}
