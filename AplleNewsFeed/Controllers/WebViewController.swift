//
//  WebViewController.swift
//  AplleNewsFeed
//
//  Created by Karlis Stekels on 12/02/2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    //MARK: - Outlets & Variables
    @IBOutlet var webView: WKWebView!
    var urlString = String()
    
    
    //MARK: - Load View
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    //MARK: - View did laod
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "WEB"
        
        guard let url = URL(string: urlString) else {return }
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    //MARK: - View Starts Navigation
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start nav")
    }
    
    //MARK: - View Finish Navigation
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("nav stopped")
    }
    
}
