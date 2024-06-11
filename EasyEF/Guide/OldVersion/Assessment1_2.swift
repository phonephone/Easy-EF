//
//  Assessment1_2.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 10/8/2566 BE.
//

import UIKit

enum NYHA {
    case Class1
    case Class2
    case Class3
    case Class4
    case ClassUnknow
}

class Assessment1_2: UIViewController {
    
    var resultAll:ResultAll?
    
    var selected2:NYHA?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ASSESSMENT1_2")
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        if sender.tag == 1 {//Class I
            selected2 = .Class1
        }
        else if sender.tag == 2 {//Class II
            selected2 = .Class2
        }
        else if sender.tag == 3 {//Class III
            selected2 = .Class3
        }
        else if sender.tag == 4 {//Class IV
            selected2 = .Class4
        }
        else if sender.tag == 5 {//Class Unknow
            selected2 = .ClassUnknow
        }
        
        resultAll?.STEP2_NYHA = selected2
        print("DONE 2\n\(String(describing: resultAll))\n")
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment1_3") as! Assessment1_3
        vc.resultAll = resultAll
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}

