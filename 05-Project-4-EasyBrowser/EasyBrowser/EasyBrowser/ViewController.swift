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
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Open",
            style: .plain,
            target: self,
            action: #selector(openTapped)
        )
        
        let url = URL(string: "https://apple.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(
            title: "Open page...",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        ac.addAction(
            UIAlertAction(title: "apple.com", style: .default, handler: openPage)
        )
        
        ac.addAction(
            UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage)
        )
        
        ac.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://\(actionTitle)") else { return }
        
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}
