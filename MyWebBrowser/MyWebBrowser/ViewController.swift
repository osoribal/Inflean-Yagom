//
//  ViewController.swift
//  MyWebBrowser
//
//  Created by 맥북 on 11/03/2020.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    // MARK:  - Properties
    // MARK:  IBOutlets
    @IBOutlet var webView: WKWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var goBackButton: UIBarButtonItem!
    @IBOutlet var reloadButton: UIBarButtonItem!
    @IBOutlet var goForwardButton: UIBarButtonItem!
    
    // MARK:  - Methods
    // MARK:  Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.webView.navigationDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let firstPageURL: URL?
        
        if let lastURL: URL = UserDefaults.standard.url(forKey: lastPageURLDefualtKey) {
            firstPageURL = lastURL
        } else {
            firstPageURL = URL(string: "https://www.google.com")
        }
        
        guard let pageURL: URL = firstPageURL else {
            return
        }
        
        let urlRequest: URLRequest = URLRequest(url: pageURL)
        self.webView.load(urlRequest)
        
    }
    
    // MARK: IBActions
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        
        self.webView.goBack()
    }
    
    @IBAction func goForward(_ sender: UIBarButtonItem) {
        
        self.webView.goForward()
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
        self.webView.reload()
    }
    
    // MARK: Custom Methods
    func showNetworkingIndicators() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func hideNetworkingIndicators() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: WKNavigationDelegate {
    
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("did finish navigation")
        
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.lastPageURL = webView.url
        }
        
        webView.evaluateJavaScript("document.title") {(value:Any?, error:Error?) in
            if let error: Error = error {
                print(error.localizedDescription)
                return
            }
            guard let title: String = value as? String else {
                return
            }
            
            self.navigationItem.title = title
        }
        self.hideNetworkingIndicators()
        goBackButton.isEnabled = true;
        goForwardButton.isEnabled = true;
        reloadButton.isEnabled = true;
    }
    
    func webView(_ webView: WKWebView, didFail navigation:WKNavigation!, withError error: Error) {
        print("did fail navigation")
        print("\(error.localizedDescription)")
        
        self.hideNetworkingIndicators()
        goBackButton.isEnabled = true;
        goForwardButton.isEnabled = true;
        reloadButton.isEnabled = true;
        let message: String = "오류발생!\n" + error.localizedDescription
        
        let alert: UIAlertController
        alert = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okayAction: UIAlertAction
        okayAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(okayAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("did start navigation")
        self.showNetworkingIndicators()
        goBackButton.isEnabled = false;
        goForwardButton.isEnabled = false;
        reloadButton.isEnabled = false;
    }
}
