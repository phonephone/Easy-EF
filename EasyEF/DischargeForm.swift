//
//  DischargeForm.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 4/9/2565 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD
import WebKit

enum dischargeType {
    case form1
    case form2
    case form3
}

class DischargeForm: UIViewController, WKNavigationDelegate {
    
    var dischargeType:dischargeType?
    
    var dischargeID: String?
    var dischargeJSON:JSON?
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var myWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DISCHARGE FORM WEB")
        
        loadDischarge()
    }
    
    func loadDischarge() {
        let parameters:Parameters = [:]
        loadRequest(method:.get, apiName:"DischargeV2/dischargeWeb", authorization:false, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS DISCHARGE WEB\(json)")
                
                self.dischargeJSON = json["data"]
                self.loadWeb()
            }
        }
    }
    
    func loadWeb() {
        var webUrlString:String?
        switch dischargeType {
        case .form1:
            headerTitle.text = "Discharge Form 1"
            webUrlString = dischargeJSON!["discharge1"].stringValue
        case .form2:
            headerTitle.text = "Discharge Form 2"
            webUrlString = dischargeJSON!["discharge2"].stringValue
        case .form3:
            headerTitle.text = "Discharge Form 3"
            webUrlString = dischargeJSON!["discharge3"].stringValue
        default:
            break
        }
        let url = URL(string: "\(webUrlString!)/\(dischargeID!)")!
        print(url)
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
        self.navigationController?.viewControllers.remove(at: (self.navigationController?.viewControllers.count)!-2)
        
        self.navigationController!.popViewController(animated: true)
        
//        navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
//            if vc.isKind(of: DischargeInput.self) || vc.isKind(of: MyViewController2.self) {
//                return false
//            } else {
//                return true
//            }
//        })
    }
}

