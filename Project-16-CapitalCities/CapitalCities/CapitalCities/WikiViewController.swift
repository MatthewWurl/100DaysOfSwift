//
//  WikiViewController.swift
//  CapitalCities
//
//  Created by Matt X on 12/15/22.
//

import UIKit
import WebKit

class WikiViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var capital: Capital!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: capital.wikiUrl))
        webView.allowsBackForwardNavigationGestures = true
    }
}
