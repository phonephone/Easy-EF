//
//  PreLogin.swift
//  AZ-Echo
//
//  Created by Truk Karawawattana on 14/7/2565 BE.
//

import UIKit
import ProgressHUD

class PreLogin: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setStatusBar(backgroundColor: .themeColor)
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        switchToHome()
    }
}
