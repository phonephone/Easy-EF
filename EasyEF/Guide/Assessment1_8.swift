//
//  Assessment1_8.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 23/8/2566 BE.
//

import UIKit

struct IndicationStruct {
    var therapiesIndication: Array<String>? = []
    var dosingIndication: Array<String>? = []
}

class Assessment1_8: UIViewController {
    
    var resultAll:ResultAll?
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var None_Main: UIStackView!
    @IBOutlet weak var None_Sub1: UIStackView!
    @IBOutlet weak var None_Sub2: UIStackView!
    @IBOutlet weak var None_Submit: UIButton!
    
    @IBOutlet weak var SubBtn1_1: UIButton!
    @IBOutlet weak var SubBtn1_2: UIButton!
    @IBOutlet weak var SubBtn2_2: UIButton!
    
    let therapieArr = ["Estimated eGFR ≥ 20 mL/min/1.73 m2",
                       "Estimated eGFR ≥ 30 mL/min/1.73 m2",
                       "K+ ≤ 5.0 mEq/L",
                       "Creatinine ≤ 2.5 mg/dl ในผู้ชาย หรือ ≤ 2.0 mg/dl ในผู้หญิง",
                       "ผู้ป่วยเป็นคนผิวสี",
                       "QRS ≥ 150 msec with LBBB pattern"
    ]
    
    let dosingArr = ["ผู้สูงอายุ (≥75 ปี)",
                     "ไตวายรุนแรง (severe renal impairment) (eGFR < 30 mL/min/1.73m2)",
                     "ตับวาย (moderate Hepatic Impairment) (Child-Pugh Class B)",
                     "เบาหวานชนิดที่ 1",
                     "กำลังให้นมบุตร",
                     "อยู่ระหว่างการฟอกไต (on dialysis)",
    ]
    
    var selected8 = IndicationStruct()
    var selected8_New = IndicationStruct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ASSESSMENT1_8")
        
        resetAll()
    }
    
    func resetAll() {
        selected8 = IndicationStruct()
        
        selected8_New.therapiesIndication = ["0","0","0","0","0","0"]
        selected8_New.dosingIndication = ["0","0","0","0","0","0"]
    }
    
    @IBAction func sub1Click(_ sender: UIButton) {
//        if sender.tag >= 11 && sender.tag <= 16 {//Therapies
//            if sender.imageView?.image == UIImage.squareBoxON {
//                sender.setImage(UIImage.squareBoxOFF, for: .normal)
//                if let index = selected8.therapiesIndication?.firstIndex(of:therapieArr[sender.tag-11]) {
//                    selected8.therapiesIndication?.remove(at: index)
//                }
//            } else {
//                sender.setImage(UIImage.squareBoxON, for: .normal)
//                selected8.therapiesIndication?.append(therapieArr[sender.tag-11])
//                specialCondition(sender)
//            }
//        }
//        print("1 = \(String(describing: selected8))")
        
        if sender.tag >= 11 && sender.tag <= 16 {//Therapies
            if sender.imageView?.image == UIImage.squareBoxON {
                sender.setImage(UIImage.squareBoxOFF, for: .normal)
                selected8_New.therapiesIndication?[sender.tag-11] = "0"
            } else {
                sender.setImage(UIImage.squareBoxON, for: .normal)
                selected8_New.therapiesIndication?[sender.tag-11] = "1"
                specialCondition(sender)
            }
        }
        print("1 = \(String(describing: selected8_New))")
    }
    
    @IBAction func sub2Click(_ sender: UIButton) {
//        if sender.tag >= 21 && sender.tag <= 26 {//Dosing
//            if sender.imageView?.image == UIImage.squareBoxON {
//                sender.setImage(UIImage.squareBoxOFF, for: .normal)
//                if let index = selected8.dosingIndication?.firstIndex(of:dosingArr[sender.tag-21]) {
//                    selected8.dosingIndication?.remove(at: index)
//                }
//            } else {
//                sender.setImage(UIImage.squareBoxON, for: .normal)
//                selected8.dosingIndication?.append(dosingArr[sender.tag-21])
//                specialCondition(sender)
//            }
//
//            myScrollView.scrollToView(view: None_Submit, animated: true)
//        }
//        print("2 = \(String(describing: selected8))")
        
        if sender.tag >= 21 && sender.tag <= 26 {//Dosing
            if sender.imageView?.image == UIImage.squareBoxON {
                sender.setImage(UIImage.squareBoxOFF, for: .normal)
                selected8_New.dosingIndication?[sender.tag-21] = "0"
            } else {
                sender.setImage(UIImage.squareBoxON, for: .normal)
                selected8_New.dosingIndication?[sender.tag-21] = "1"
                specialCondition(sender)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.myScrollView.scrollToView(view: self.None_Submit, animated: true)
            }
        }
        print("2 = \(String(describing: selected8_New))")
    }
    
    func specialCondition(_ sender: UIButton) {
        if sender == SubBtn1_1 {
            clearOther(SubBtn1_2)
            //clearOther(SubBtn2_2)
        }
        else if sender == SubBtn1_2 {
            clearOther(SubBtn1_1)
            clearOther(SubBtn2_2)
        }
        else if sender == SubBtn2_2 {
            //clearOther(SubBtn1_1)
            clearOther(SubBtn1_2)
        }
    }
    
    func clearOther(_ sender: UIButton) {
//        if sender == SubBtn1_1 {//eGFR ≥ 30
//            SubBtn1_1.setImage(UIImage.squareBoxOFF, for: .normal)
//            if let index = selected8.therapiesIndication?.firstIndex(of:therapieArr[0]) {
//                selected8.therapiesIndication?.remove(at: index)
//            }
//        }
//        else if sender == SubBtn1_2 {//eGFR ≥ 20
//            SubBtn1_2.setImage(UIImage.squareBoxOFF, for: .normal)
//            if let index = selected8.therapiesIndication?.firstIndex(of:therapieArr[1]) {
//                selected8.therapiesIndication?.remove(at: index)
//            }
//        }
//        else if sender == SubBtn2_2 {//eGFR < 30
//            SubBtn2_2.setImage(UIImage.squareBoxOFF, for: .normal)
//            if let index = selected8.dosingIndication?.firstIndex(of:dosingArr[1]) {
//                selected8.dosingIndication?.remove(at: index)
//            }
//        }
        
        if sender == SubBtn1_1 {//eGFR ≥ 30
            SubBtn1_1.setImage(UIImage.squareBoxOFF, for: .normal)
            selected8_New.therapiesIndication?[0] = "0"
        }
        else if sender == SubBtn1_2 {//eGFR ≥ 20
            SubBtn1_2.setImage(UIImage.squareBoxOFF, for: .normal)
            selected8_New.therapiesIndication?[1] = "0"
        }
        else if sender == SubBtn2_2 {//eGFR < 30
            SubBtn2_2.setImage(UIImage.squareBoxOFF, for: .normal)
            selected8_New.dosingIndication?[1] = "0"
        }
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        submit()
    }
    
    func submit() {
        resultAll?.STEP8_Indication = selected8_New
        print("DONE 8\n\(String(describing: resultAll))\n")
        
        //let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment_Result") as! Assessment_Result
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment_Web") as! Assessment_Web
        vc.resultAll = resultAll
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}




