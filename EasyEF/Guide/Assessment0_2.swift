//
//  Assessment0_2.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 10/8/2566 BE.
//

import UIKit

class Assessment0_2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ASSESSMENT0_2")
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        if sender.tag == 1 {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment_Fine") as! Assessment_Fine
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else if sender.tag == 2 {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment0_3") as! Assessment0_3
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}
