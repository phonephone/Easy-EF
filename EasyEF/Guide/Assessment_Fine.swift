//
//  Assessment_Fine.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 10/8/2566 BE.
//

import UIKit

class Assessment_Fine: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ASSESSMENT FINE")
    }
    
    @IBAction func back(_ sender: UIButton) {
         self.navigationController!.popToRootViewController(animated: true)
    }
}
