//
//  Assessment1_5.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 23/8/2566 BE.
//

import UIKit

enum BetaBlocker {
    case None
    case Bisoprolol
    case Carvedilol
    case CR
    case Metoprolol
}

struct BetaBlockerStruct {
    var bbName: BetaBlocker?
    var bbQuestion1: Bool?
    var bbQuestion2: Bool?
    var bbIndicateCI: Array<String>? = []
}

class Assessment1_5: UIViewController {
    
    var resultAll:ResultAll?
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var None_Main: UIStackView!
    @IBOutlet weak var None_Sub1: UIStackView!
    @IBOutlet weak var None_Btn: UIButton!
    @IBOutlet weak var None_Submit: UIButton!
    
    @IBOutlet weak var Bisoprolol_Main: UIStackView!
    @IBOutlet weak var Bisoprolol_Sub1: UIStackView!
    @IBOutlet weak var Bisoprolol_Sub2: UIStackView!
    @IBOutlet weak var Bisoprolol_Submit: UIButton!
    
    @IBOutlet weak var Carvedilol_Main: UIStackView!
    @IBOutlet weak var Carvedilol_Sub1: UIStackView!
    @IBOutlet weak var Carvedilol_Sub2: UIStackView!
    @IBOutlet weak var Carvedilol_Submit: UIButton!
    
    @IBOutlet weak var CR_Main: UIStackView!
    @IBOutlet weak var CR_Sub1: UIStackView!
    @IBOutlet weak var CR_Sub2: UIStackView!
    @IBOutlet weak var CR_Submit: UIButton!
    
    @IBOutlet weak var Metoprolol_Main: UIStackView!
    @IBOutlet weak var Metoprolol_Sub1: UIStackView!
    @IBOutlet weak var Metoprolol_Sub2: UIStackView!
    @IBOutlet weak var Metoprolol_Submit: UIButton!
    
    let BBarr = ["None","Bisoprolol","Carvedilol","Carvedilol CR","Metoprolol Succinate extended release (metoprolol CR/XL)"]
    
    let CIarr = ["ไม่มี",
                 "ภาวะภูมิไว (hypersensitivity) ต่อปัจจัยใดก็ได้",
                 "ภาวะช็อกจากระบบไหลเวียนโลหิตหัวใจ (cardiogenic shock)",
                 "Second or third degree AV block",
                 "ภาวะหัวใจเต้นช้ารุนแรง (severe bradycardia) (นอกจากใส่เครื่องกระตุ้นไฟฟ้าหัวใจ)",
                 "โรคปมไฟฟ้าหัวใจเสื่อม (sick sinus syndrome)",
                 "Decompensated cardiac failure",
                 "Severe hepatic impairment",
                 "Symptomatic hypotension",
                 "โรคเลือดส่วนปลายอุดตันรุนแรง (severe forms of peripheral arterial occlusive disease) หรือ โรคเรเนาด์ (raynaud syndrome)",
                 "เนื้องอกต่อมหมวกไต (adrenal gland tumors) ที่ยังไม่ได้รักษา หรือ เนื้องอกต่อมหมวกไตชนิดฟีโอโครโมไซโตมา (phaeochromocytoma)",
    ]
    
    var selected5 = BetaBlockerStruct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ASSESSMENT1_5")
        
        resetAll()
    }
    
    func resetAll() {
        None_Main.isHidden = true
        None_Submit.isHidden = true
        
        Bisoprolol_Main.isHidden = true
        Bisoprolol_Submit.isHidden = true
        
        Carvedilol_Main.isHidden = true
        Carvedilol_Submit.isHidden = true
        
        CR_Main.isHidden = true
        CR_Submit.isHidden = true
        
        Metoprolol_Main.isHidden = true
        Metoprolol_Submit.isHidden = true
        
        selected5 = BetaBlockerStruct()
        
        clearAllCheckbox(None_Main, multipleChoice: true)
        clearAllCheckbox(Bisoprolol_Main)
        clearAllCheckbox(Carvedilol_Main)
        clearAllCheckbox(CR_Main)
        clearAllCheckbox(Metoprolol_Main)
    }
    
    @IBAction func mainClick(_ sender: UIButton) {
        resetAll()
        
        if sender.tag == 1 {//NONE
            None_Main.isHidden = false
            selected5.bbName = .None
        }
        if sender.tag == 2 {//Bisoprolol
            Bisoprolol_Main.isHidden = false
            selected5.bbName = .Bisoprolol
        }
        else if sender.tag == 3 {//Carvedilol
            Carvedilol_Main.isHidden = false
            selected5.bbName = .Carvedilol
        }
        else if sender.tag == 4 {//CR
            CR_Main.isHidden = false
            selected5.bbName = .CR
        }
        else if sender.tag == 5 {//Metoprolol
            Metoprolol_Main.isHidden = false
            selected5.bbName = .Metoprolol
        }
    }
    
    @IBAction func sub1Click(_ sender: UIButton) {//NONE
        if sender.tag == 11 {//ไม่มี
            clearAllCheckbox(None_Main, multipleChoice: true)
            sender.setImage(UIImage.squareBoxON, for: .normal)
            
            selected5.bbIndicateCI = []
            selected5.bbIndicateCI?.append(CIarr[0])
        }
        else if sender.tag >= 12 && sender.tag <= 21 {//อื่นๆ
            None_Btn.setImage(UIImage.squareBoxOFF, for: .normal)
            if let noneIndex = selected5.bbIndicateCI?.firstIndex(of:CIarr[0]) {
                selected5.bbIndicateCI?.remove(at: noneIndex)
            }
            
            if sender.imageView?.image == UIImage.squareBoxON {
                sender.setImage(UIImage.squareBoxOFF, for: .normal)
                if let index = selected5.bbIndicateCI?.firstIndex(of:CIarr[sender.tag-11]) {
                    selected5.bbIndicateCI?.remove(at: index)
                }
            } else {
                sender.setImage(UIImage.squareBoxON, for: .normal)
                selected5.bbIndicateCI?.append(CIarr[sender.tag-11])
            }
        }
        //print("1 = \(selected5)")
        checkSelected()
    }
    
    @IBAction func sub2Click(_ sender: UIButton) {//Bisoprolol
        checkboxClick(sender)
        if sender.tag == 211 {//Bisoprolol Q1 YES
            selected5.bbQuestion1 = true
        }
        else if sender.tag == 212 {//Bisoprolol Q1 NO
            selected5.bbQuestion1 = false
        }
        else if sender.tag == 221 {//Bisoprolol Q2 YES
            selected5.bbQuestion2 = true
        }
        else if sender.tag == 222 {//Bisoprolol Q2 NO
            selected5.bbQuestion2 = false
        }
        //print("2 = \(selected5)")
        checkSelected()
    }
    
    @IBAction func sub3Click(_ sender: UIButton) {//Carvedilol
        checkboxClick(sender)
        if sender.tag == 311 {//Carvedilol Q1 YES
            selected5.bbQuestion1 = true
        }
        else if sender.tag == 312 {//Carvedilol Q1 NO
            selected5.bbQuestion1 = false
        }
        else if sender.tag == 321 {//Carvedilol Q2 YES
            selected5.bbQuestion2 = true
        }
        else if sender.tag == 322 {//Carvedilol Q2 NO
            selected5.bbQuestion2 = false
        }
        //print("3 = \(selected5)")
        checkSelected()
    }
    
    @IBAction func sub4Click(_ sender: UIButton) {//CR
        checkboxClick(sender)
        if sender.tag == 411 {//CR Q1 YES
            selected5.bbQuestion1 = true
        }
        else if sender.tag == 412 {//CR Q1 NO
            selected5.bbQuestion1 = false
        }
        else if sender.tag == 421 {//CR Q2 YES
            selected5.bbQuestion2 = true
        }
        else if sender.tag == 422 {//CR Q2 NO
            selected5.bbQuestion2 = false
        }
        //print("4 = \(selected5)")
        checkSelected()
    }
    
    @IBAction func sub5Click(_ sender: UIButton) {//Metoprolol
        checkboxClick(sender)
        if sender.tag == 511 {//Metoprolol Q1 YES
            selected5.bbQuestion1 = true
        }
        else if sender.tag == 512 {//Metoprolol Q1 NO
            selected5.bbQuestion1 = false
        }
        else if sender.tag == 521 {//Metoprolol Q2 YES
            selected5.bbQuestion2 = true
        }
        else if sender.tag == 522 {//Metoprolol Q2 NO
            selected5.bbQuestion2 = false
        }
        //print("5 = \(selected5)")
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
        Bisoprolol_Submit.isHidden = true
        Carvedilol_Submit.isHidden = true
        CR_Submit.isHidden = true
        Metoprolol_Submit.isHidden = true
        
        if selected5.bbIndicateCI != [] {
            None_Submit.isHidden = false
            //myScrollView.scrollToView(view: None_Submit, animated: true)
            //myScrollView.scrollToBottom()
        }
        else if selected5.bbName != nil && selected5.bbQuestion1 != nil && selected5.bbQuestion2 != nil {
            switch selected5.bbName {
            case .Bisoprolol:
                Bisoprolol_Submit.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.myScrollView.scrollToView(view: self.Bisoprolol_Submit, animated: true)
                }
                
            case .Carvedilol:
                Carvedilol_Submit.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.myScrollView.scrollToView(view: self.Carvedilol_Submit, animated: true)
                }
                
            case .CR:
                CR_Submit.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.myScrollView.scrollToView(view: self.CR_Submit, animated: true)
                }
                
            case .Metoprolol:
                Metoprolol_Submit.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.myScrollView.scrollToView(view: self.Metoprolol_Submit, animated: true)
                }
                
            default:
                break
            }
            //myScrollView.scrollToBottom()
        }
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        submit()
    }
    
    func submit() {
        resultAll?.STEP5_BetaBlocker = selected5
        print("DONE 5\n\(String(describing: resultAll))\n")
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment1_6") as! Assessment1_6
        vc.resultAll = resultAll
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}


