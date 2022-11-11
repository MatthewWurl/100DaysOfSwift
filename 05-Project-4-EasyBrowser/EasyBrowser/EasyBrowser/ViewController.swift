//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Matt X on 11/8/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websiteToLoad: String!
    var allowedWebsites: [String]!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let back = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward"),
            style: .plain,
            target: webView,
            action: #selector(webView.goBack)
        )
        let forward = UIBarButtonItem(
            image: UIImage(systemName: "arrow.forward"),
            style: .plain,
            target: webView,
            action: #selector(webView.goForward)
        )
        let refresh = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: webView,
            action: #selector(webView.reload)
        )
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, back, forward, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
        
        let url = URL(string: "https://\(websiteToLoad!)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in allowedWebsites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
        
        // ISSUE SHOWING ALERT...
//        showUnallowedWebsiteAlert()
    }
    
    func showUnallowedWebsiteAlert() {
        let ac = UIAlertController(
            title: "Uh-oh!",
            message: "Sorry, that website is not allowed!",
            preferredStyle: .alert
        )
        
        ac.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        
        present(ac, animated: true)
    }
}
