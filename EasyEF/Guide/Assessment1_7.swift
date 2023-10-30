//
//  Assessment1_7.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 23/8/2566 BE.
//

import UIKit

class Assessment1_7: UIViewController {
    
    var resultAll:ResultAll?
    
    var selected7: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ASSESSMENT1_7")
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        if sender.tag == 1 {//Not on diueretics
            selected7 = false
        }
        else if sender.tag == 2 {//On diueretics
            selected7 = true
        }
        
        resultAll?.STEP7_Diuretics = selected7
        print("DONE 7\n\(String(describing: resultAll))\n")
        
        if resultAll?.STEP2_NYHA == .Class2 || resultAll?.STEP2_NYHA == .Class3 || resultAll?.STEP2_NYHA == .Class4 {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment1_8") as! Assessment1_8
            vc.resultAll = resultAll
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else {//Class 1 , Class Unknow
            //let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment_Result") as! Assessment_Result
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment_Web") as! Assessment_Web
            vc.resultAll = resultAll
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}

