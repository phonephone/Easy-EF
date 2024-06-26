//
//  Web.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 26/8/2565 BE.
//

import UIKit
import ProgressHUD
import WebKit

class Web: UIViewController, WKNavigationDelegate {
    
    var titleString:String?
    var webUrlString:String?
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var myWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("WEB")
        
        //print(webUrlString)
        
        headerTitle.text = titleString
        
        let url = URL(string: webUrlString!)!
        //let url = URL(string: "https://www.google.com")!
        myWebView.load(URLRequest(url: url))
        myWebView.navigationDelegate = self
        myWebView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingHUD()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}
