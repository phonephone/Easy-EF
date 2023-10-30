//
//  Assessment1_6.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 23/8/2566 BE.
//

import UIKit

class Assessment1_6: UIViewController {
    
    var resultAll:ResultAll?
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var None_Main: UIStackView!
    @IBOutlet weak var None_Sub1: UIStackView!
    @IBOutlet weak var None_Btn: UIButton!
    @IBOutlet weak var None_Submit: UIButton!
    
    var selected6: Array<String>? = []
    var selected6_New: Array<String>? = []
    let addMedArr = ["Hydralazine + isosorbine dinitrate","Ivabradine","None of these"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ASSESSMENT1_6")
        
        resetAll()
    }
    
    func resetAll() {
        selected6 = []
        selected6_New = ["0","0","0"]
        
        None_Submit.isHidden = true
        
        clearAllCheckbox(None_Main, multipleChoice: true)
    }
    
    @IBAction func sub1Click(_ sender: UIButton) {//NONE
//        if sender.tag >= 11 && sender.tag <= 12 {//อื่นๆ
//            None_Btn.setImage(UIImage.squareBoxOFF, for: .normal)
//            if let noneIndex = selected6?.firstIndex(of:addMedArr[2]) {
//                selected6?.remove(at: noneIndex)
//            }
//
//            if sender.imageView?.image == UIImage.squareBoxON {
//                sender.setImage(UIImage.squareBoxOFF, for: .normal)
//                if let index = selected6?.firstIndex(of:addMedArr[sender.tag-11]) {
//                    selected6?.remove(at: index)
//                }
//            } else {
//                sender.setImage(UIImage.squareBoxON, for: .normal)
//                selected6?.append(addMedArr[sender.tag-11])
//            }
//        }
//        else if sender.tag == 13 {//ไม่มี
//            clearAllCheckbox(None_Main, multipleChoice: true)
//            sender.setImage(UIImage.squareBoxON, for: .normal)
//
//            selected6 = []
//            selected6?.append(addMedArr[2])
//        }
//        print("1 = \(String(describing: selected6))")
//        checkSelected()
        
        if sender.tag >= 11 && sender.tag <= 12  {//อื่นๆ
            None_Btn.setImage(UIImage.squareBoxOFF, for: .normal)
            selected6_New?[2] = "0"
            
            if sender.imageView?.image == UIImage.squareBoxON {
                sender.setImage(UIImage.squareBoxOFF, for: .normal)
                selected6_New?[sender.tag-11] = "0"
            } else {
                sender.setImage(UIImage.squareBoxON, for: .normal)
                selected6_New?[sender.tag-11] = "1"
            }
        }
        else if sender.tag == 13 {//ไม่มี
            clearAllCheckbox(None_Main, multipleChoice: true)
            sender.setImage(UIImage.squareBoxON, for: .normal)
            
            selected6_New = ["0","0","1"]
        }
        
        print("1 = \(String(describing: selected6_New))")
        checkSelected()
    }
    
    func checkboxClick(_ sender: UIButton) {
        for view in sender.superview!.superview!.subviews as [UIView] {
            for subview in view.subviews as [UIView] {
                if let btn = subview as? UIButton {
                    btn.setImage(UIImage.circleBoxOFF, for: .normal)
                }
            }
        }
        sender.setImage(UIImage.circleBoxON, for: .normal)
    }
    
    func clearAllCheckbox(_ view: UIView, multipleChoice: Bool = false) {
        for mainStack in view.subviews as [UIView] {//Main
            for subStack in mainStack.subviews as [UIView] {//Sub
                for view in subStack.subviews as [UIView] {
                    if let btn = view as? UIButton {
                        if !multipleChoice {
                            btn.setImage(UIImage.circleBoxOFF, for: .normal)
                        }
                        else {
                            btn.setImage(UIImage.squareBoxOFF, for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    func checkSelected() {
        None_Submit.isHidden = true
        
//        if selected6 != [] {
//            None_Submit.isHidden = false
//            //myScrollView.scrollToView(view: None_Submit, animated: true)
//            //myScrollView.scrollToBottom()
//        }
        
        if selected6_New != ["0","0","0"] {
            None_Submit.isHidden = false
        }
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        submit()
    }
    
    func submit() {
        resultAll?.STEP6_AdditionalMedicine = selected6_New
        print("DONE 6\n\(String(describing: resultAll))\n")
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment1_7") as! Assessment1_7
        vc.resultAll = resultAll
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}



