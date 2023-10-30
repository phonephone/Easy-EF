//
//  Assessment0_1.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 24/5/2566 BE.
//

import UIKit

class Assessment0_1: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ASSESSMENT0_1")
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        if sender.tag == 1 {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment0_2") as! Assessment0_2
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else if sender.tag == 2 {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment_Fine") as! Assessment_Fine
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
}
