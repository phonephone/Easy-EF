//
//  Assessment0_3.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 10/8/2566 BE.
//

import UIKit

class Assessment0_3: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ASSESSMENT0_3")
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        if sender.tag == 1 {//Chronic
//            let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment1_1") as! Assessment1_1
//            self.navigationController!.pushViewController(vc, animated: true)
            
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment_All") as! Assessment_All
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else if sender.tag == 2 {//Acute
            showComingSoon()
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}

