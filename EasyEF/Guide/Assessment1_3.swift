//
//  Assessment1_3.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 24/5/2566 BE.
//

import UIKit

enum LVEF_Med {
    case BB
    case RASi_ARNI
    case MRA
    case SGLT2i
}

enum LVEF_Med_Class {
    case Ia
    case IIa
    case IIb
}

struct LVEF_MedStruct {
    var medGroup: LVEF_Med?
    var medClass: LVEF_Med_Class?
}

class Assessment1_3: UIViewController {
    
    var resultAll:ResultAll?
    
    @IBOutlet weak var LVEFLabel: UILabel!
    
    @IBOutlet weak var SGLT2i_Btn: UIButton!
    @IBOutlet weak var MRA_Btn: UIButton!
    @IBOutlet weak var RASi_Btn: UIButton!
    @IBOutlet weak var BB_Btn: UIButton!
    
    var selected3 = LVEF_MedStruct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ASSESSMENT1_3")
        
        let color1A = UIColor.themeColor
        let color2A = UIColor(named: "Class2A")
        let color2B = UIColor(named: "Class2B")
        
        switch resultAll?.STEP1_LVEF {
        case .Reduced:
            LVEFLabel.text = "Reduced"
            
            BB_Btn.isHidden = false
            
            SGLT2i_Btn.backgroundColor = color1A
            MRA_Btn.backgroundColor = color1A
            RASi_Btn.backgroundColor = color1A
            BB_Btn.backgroundColor = color1A
            
            RASi_Btn.setTitle("RASi/ARNI", for: .normal)
            
        case .Mildly:
            LVEFLabel.text = "Mildly reduced"
            
            BB_Btn.isHidden = false
            
            SGLT2i_Btn.backgroundColor = color1A
            MRA_Btn.backgroundColor = color2A
            RASi_Btn.backgroundColor = color2B
            BB_Btn.backgroundColor = color2B
            
            RASi_Btn.setTitle("RASi/ARNI", for: .normal)
            
        case .Preserved:
            LVEFLabel.text = "Preserved"
            
            BB_Btn.isHidden = true
            
            SGLT2i_Btn.backgroundColor = color1A
            MRA_Btn.backgroundColor = color2A
            RASi_Btn.backgroundColor = color2B
            
            RASi_Btn.setTitle("RASi/ARNI/ARB", for: .normal)
            
        default :
            break
        }
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        if sender.tag == 1 {//SGLT2i
            selected3.medGroup = .SGLT2i
        }
        else if sender.tag == 2 {//MRA
            selected3.medGroup = .MRA
        }
        else if sender.tag == 3 {//RASi/ARNI/ARB
            selected3.medGroup = .RASi_ARNI
        }
        else if sender.tag == 4 {//BB
            selected3.medGroup = .BB
        }
        
        switch resultAll?.STEP1_LVEF {
        case .Reduced:
            selected3.medClass = .Ia
            
        case .Mildly:
            if sender.tag == 1 {//SGLT2i
                selected3.medClass = .Ia
            }
            else if sender.tag == 2 {//MRA
                selected3.medClass = .IIa
            }
            else if sender.tag == 3 || sender.tag == 4 {//RASi/ARNI , //BB
                selected3.medClass = .IIb
            }
            
        case .Preserved:
            if sender.tag == 1 {//SGLT2i
                selected3.medClass = .Ia
            }
            else if sender.tag == 2 {//MRA
                selected3.medClass = .IIa
            }
            else if sender.tag == 3 {//RASi/ARNI/ARB
                selected3.medClass = .IIb
            }
            
        default :
            break
        }
        
        resultAll?.STEP3_LVEF_Med = selected3
        print("DONE 3\n\(String(describing: resultAll))\n")
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment1_4") as! Assessment1_4
        vc.resultAll = resultAll
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}

