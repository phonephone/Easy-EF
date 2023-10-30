//
//  Assessment1_4.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 23/8/2566 BE.
//

import UIKit

enum RASInhibitor {
    case ARNI
    case ACEI
    case ARB
    case None
}

struct RASInhibitorStruct {
    var rasGroup: RASInhibitor?
    var rasName: String?
    var rasQuestion1: Bool?
    var rasQuestion2: Bool?
    var rasIndicateCI: Array<String>? = []
    var rasIndicateCI2: Array<String>? = []
    var rasIndicateCI3: Array<String>? = []
}

class Assessment1_4: UIViewController {
    
    var resultAll:ResultAll?
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var ACEI_Main: UIStackView!
    @IBOutlet weak var ACEI_Sub1: UIStackView!
    @IBOutlet weak var ACEI_Sub2: UIStackView!
    @IBOutlet weak var ACEI_Sub3: UIStackView!
    @IBOutlet weak var ACEI_Submit: UIButton!
    
    @IBOutlet weak var ARB_Main: UIStackView!
    @IBOutlet weak var ARB_Sub1: UIStackView!
    @IBOutlet weak var ARB_Sub2: UIStackView!
    @IBOutlet weak var ARB_Sub3: UIStackView!
    @IBOutlet weak var ARB_Submit: UIButton!
    
    @IBOutlet weak var None_Main: UIStackView!
    @IBOutlet weak var None_Sub1: UIStackView!
    @IBOutlet weak var None_Btn: UIButton!
    @IBOutlet weak var None_Sub2: UIStackView!
    @IBOutlet weak var None_Sub3: UIStackView!
    @IBOutlet weak var None_Sub4: UIStackView!
    @IBOutlet weak var None_Submit: UIButton!
    
    let ACEIarr = ["Captopril","Enalapril","Fosinopril","Lisinopril","Perindopril","Quinapril","Ramipril","Trandolapril"]
    
    let ARBarr = ["Candesartan","Losartan","Valsartan"]
    
    let CIarr = ["ไม่มี",
                 "ผู้ป่วยเบาหวานที่ใช้ยา Aliskiren",
                 "หญิงตั้งครรภ์",
                 "มีประวัติ ภาวะภูมิไว (Hypersensitivity) กับ ACEI",
                 "มีประวัติเนื้อเยื่อบวมจากการแพ้ (Angioedema)",
                 "ไอ (ผลข้างเคียงทั่วไปที่เกิดจาก ACEI)",
                 "มีประวัติ ภาวะภูมิไว (Hypersensitivity) กับ ARB",
    ]
    
    var selected4 = RASInhibitorStruct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ASSESSMENT1_4")
        
        resetAll()
    }
    
    func resetAll() {
        ACEI_Main.isHidden = true
        ACEI_Submit.isHidden = true
        
        ARB_Main.isHidden = true
        ARB_Submit.isHidden = true
        
        None_Main.isHidden = true
        None_Submit.isHidden = true
        
        selected4 = RASInhibitorStruct()
        
        clearAllCheckbox(ACEI_Main)
        clearAllCheckbox(ARB_Main)
        clearAllCheckbox(None_Main, multipleChoice: true)
    }
    
    @IBAction func mainClick(_ sender: UIButton) {
        resetAll()
        
        if sender.tag == 1 {//ARNI
            selected4.rasGroup = .ARNI
            submit()
        }
        if sender.tag == 2 {//ACEI
            ACEI_Main.isHidden = false
            selected4.rasGroup = .ACEI
        }
        else if sender.tag == 3 {//ARB
            ARB_Main.isHidden = false
            selected4.rasGroup = .ARB
        }
        else if sender.tag == 4 {//None
            None_Main.isHidden = false
            selected4.rasGroup = .None
        }
    }
    
    @IBAction func sub2Click(_ sender: UIButton) {//ACEI
        checkboxClick(sender)
        if sender.tag >= 21 && sender.tag <= 28 {//ACEI Name
            selected4.rasName = ACEIarr[sender.tag-21]
        }
        else if sender.tag == 221 {//ACEI Q1 YES
            selected4.rasQuestion1 = true
        }
        else if sender.tag == 222 {//ACEI Q1 NO
            selected4.rasQuestion1 = false
        }
        else if sender.tag == 231 {//ACEI Q2 YES
            selected4.rasQuestion2 = true
        }
        else if sender.tag == 232 {//ACEI Q2 NO
            selected4.rasQuestion2 = false
        }
        //print("2 = \(selected4)")
        checkSelected()
    }
    
    @IBAction func sub3Click(_ sender: UIButton) {//ARB
        checkboxClick(sender)
        if sender.tag >= 31 && sender.tag <= 33 {//ARB Name
            selected4.rasName = ARBarr[sender.tag-31]
        }
        else if sender.tag == 321 {//ARB Q1 YES
            selected4.rasQuestion1 = true
        }
        else if sender.tag == 322 {//ARB Q1 NO
            selected4.rasQuestion1 = false
        }
        else if sender.tag == 331 {//ARB Q2 YES
            selected4.rasQuestion2 = true
        }
        else if sender.tag == 332 {//ARB Q2 NO
            selected4.rasQuestion2 = false
        }
        //print("3 = \(selected4)")
        checkSelected()
    }
    
    @IBAction func sub4Click(_ sender: UIButton) {//NONE
        if sender.tag == 41 {//ไม่มี
            clearAllCheckbox(None_Main, multipleChoice: true)
            sender.setImage(UIImage.squareBoxON, for: .normal)
            
            selected4.rasIndicateCI = []
            selected4.rasIndicateCI2 = []
            selected4.rasIndicateCI3 = []
            selected4.rasIndicateCI?.append(CIarr[0])
        }
        else if sender.tag >= 42 && sender.tag <= 43 {//อื่นๆ
            None_Btn.setImage(UIImage.squareBoxOFF, for: .normal)
            if let noneIndex = selected4.rasIndicateCI?.firstIndex(of:CIarr[0]) {
                selected4.rasIndicateCI?.remove(at: noneIndex)
            }
            
            if sender.imageView?.image == UIImage.squareBoxON {
                sender.setImage(UIImage.squareBoxOFF, for: .normal)
                if let index = selected4.rasIndicateCI?.firstIndex(of:CIarr[sender.tag-41]) {
                    selected4.rasIndicateCI?.remove(at: index)
                }
            } else {
                sender.setImage(UIImage.squareBoxON, for: .normal)
                selected4.rasIndicateCI?.append(CIarr[sender.tag-41])
            }
        }
        else if sender.tag >= 44 && sender.tag <= 46 {//อื่นๆ
            None_Btn.setImage(UIImage.squareBoxOFF, for: .normal)
            if let noneIndex = selected4.rasIndicateCI2?.firstIndex(of:CIarr[0]) {
                selected4.rasIndicateCI2?.remove(at: noneIndex)
            }
            
            if sender.imageView?.image == UIImage.squareBoxON {
                sender.setImage(UIImage.squareBoxOFF, for: .normal)
                if let index = selected4.rasIndicateCI2?.firstIndex(of:CIarr[sender.tag-41]) {
                    selected4.rasIndicateCI2?.remove(at: index)
                }
            } else {
                sender.setImage(UIImage.squareBoxON, for: .normal)
                selected4.rasIndicateCI2?.append(CIarr[sender.tag-41])
            }
        }
        else if sender.tag >= 47 && sender.tag <= 47 {//อื่นๆ
            None_Btn.setImage(UIImage.squareBoxOFF, for: .normal)
            if let noneIndex = selected4.rasIndicateCI3?.firstIndex(of:CIarr[0]) {
                selected4.rasIndicateCI3?.remove(at: noneIndex)
            }
            
            if sender.imageView?.image == UIImage.squareBoxON {
                sender.setImage(UIImage.squareBoxOFF, for: .normal)
                if let index = selected4.rasIndicateCI3?.firstIndex(of:CIarr[sender.tag-41]) {
                    selected4.rasIndicateCI3?.remove(at: index)
                }
            } else {
                sender.setImage(UIImage.squareBoxON, for: .normal)
                selected4.rasIndicateCI3?.append(CIarr[sender.tag-41])
            }
        }
        print("4 = \(selected4)")
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
        ACEI_Submit.isHidden = true
        ARB_Submit.isHidden = true
        None_Submit.isHidden = true
        
        if selected4.rasName != nil && selected4.rasQuestion1 != nil && selected4.rasQuestion2 != nil {
            switch selected4.rasGroup {
            case .ACEI:
                ACEI_Submit.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.myScrollView.scrollToView(view: self.ACEI_Submit, animated: true)
                }
                
            case .ARB:
                ARB_Submit.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.myScrollView.scrollToView(view: self.ARB_Submit, animated: true)
                }
                
            default:
                break
            }
            //myScrollView.scrollToBottom()
            
        }
        else if selected4.rasIndicateCI != [] || selected4.rasIndicateCI2 != [] || selected4.rasIndicateCI3 != [] {
            None_Submit.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.myScrollView.scrollToView(view: self.None_Submit, animated: true)
            }
            //myScrollView.scrollToBottom()
        }
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        submit()
    }
    
    func submit() {
        resultAll?.STEP4_RASInhibitor = selected4
        print("DONE 4\n\(String(describing: resultAll))\n")
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment1_5") as! Assessment1_5
        vc.resultAll = resultAll
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}

