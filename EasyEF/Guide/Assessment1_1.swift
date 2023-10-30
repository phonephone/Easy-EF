//
//  Assessment1_1.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 10/8/2566 BE.
//

import UIKit

enum LVEF {
    case Reduced
    case Mildly
    case Preserved
}

struct ResultAll {
    var STEP1_LVEF: LVEF?
    var STEP2_NYHA: NYHA?
    var STEP3_LVEF_Med: LVEF_MedStruct?
    var STEP4_RASInhibitor: RASInhibitorStruct?
    var STEP5_BetaBlocker: BetaBlockerStruct?
    var STEP6_AdditionalMedicine: Array<String>?
    var STEP7_Diuretics: Bool?
    var STEP8_Indication: IndicationStruct?
}

class Assessment1_1: UIViewController {
    
    var resultAll = ResultAll()
    
    var selected1:LVEF?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ASSESSMENT1_1")
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        if sender.tag == 1 {//Reduced
            selected1 = .Reduced
        }
        else if sender.tag == 2 {//Mildly Reduced
            selected1 = .Mildly
        }
        else if sender.tag == 3 {//Preserved
            selected1 = .Preserved
        }
        
        resultAll.STEP1_LVEF = selected1
        print("DONE 1\n\(String(describing: resultAll))\n")
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment1_2") as! Assessment1_2
        vc.resultAll = resultAll
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}
