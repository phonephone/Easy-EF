//
//  Assessment_Result.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 23/8/2566 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class Assessment_Result: UIViewController {
    
    var resultAll:ResultAll?
    
    var resultJSON:JSON?
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ASSESSMENT_RESULT")
        
        //print("ALL \(String(describing: resultAll))")
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = .clear
        //myTableView.tableFooterView = UIView(frame: .zero)
        //myTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.myTableView.frame.size.width, height: 1))
        
        loadResult()
    }
    
    func loadResult() {
        var parameters:Parameters = ["id_user":SceneDelegate.GlobalVariables.userID]
        
        //STEP1 LVEF
        switch resultAll?.STEP1_LVEF {
        case .Reduced:
            parameters.updateValue("reduced", forKey: "lvef_1")
        case .Mildly:
            parameters.updateValue("mildly", forKey: "lvef_1")
        case .Preserved:
            parameters.updateValue("preserved", forKey: "lvef_1")
        default :
            break
        }
        
        //STEP2 NYHA CLASS
        switch resultAll?.STEP2_NYHA {
        case .Class1:
            parameters.updateValue("1", forKey: "nyha_2")
        case .Class2:
            parameters.updateValue("2", forKey: "nyha_2")
        case .Class3:
            parameters.updateValue("3", forKey: "nyha_2")
        case .Class4:
            parameters.updateValue("4", forKey: "nyha_2")
        case .ClassUnknow:
            parameters.updateValue("unknow", forKey: "nyha_2")
        default :
            break
        }
        
        //STEP3 MED+CLASS
        switch resultAll?.STEP3_LVEF_Med?.medGroup {
        case .SGLT2i:
            parameters.updateValue("sg", forKey: "mildly_3")
        case .MRA:
            parameters.updateValue("ma", forKey: "mildly_3")
        case .RASi_ARNI:
            parameters.updateValue("ra", forKey: "mildly_3")
        case .BB:
            parameters.updateValue("bb", forKey: "mildly_3")
        default :
            break
        }
        
        switch resultAll?.STEP3_LVEF_Med?.medClass {
        case .Ia:
            parameters.updateValue("1a", forKey: "class_3")
        case .IIa:
            parameters.updateValue("2a", forKey: "class_3")
        case .IIb:
            parameters.updateValue("2b", forKey: "class_3")
        default :
            break
        }
        
        //STEP4 RASINHIBITOR
        switch resultAll?.STEP4_RASInhibitor?.rasGroup {
        case .ARNI:
            parameters.updateValue("arni", forKey: "ras_4")
            
        case .ACEI:
            parameters.updateValue("acei", forKey: "ras_4")
            parameters.updateValue(resultAll!.STEP4_RASInhibitor!.rasName!.lowercased(), forKey: "acei_4")
            switch resultAll?.STEP4_RASInhibitor?.rasQuestion1 {
            case true:
                parameters.updateValue("y", forKey: "acei_yn_contraindications_4")
            case false:
                parameters.updateValue("n", forKey: "acei_yn_contraindications_4")
            default :
                break
            }
            switch resultAll?.STEP4_RASInhibitor?.rasQuestion2 {
            case true:
                parameters.updateValue("y", forKey: "acei_yn_patient_4")
            case false:
                parameters.updateValue("n", forKey: "acei_yn_patient_4")
            default :
                break
            }
                
        case .ARB:
            parameters.updateValue("arb", forKey: "ras_4")
            parameters.updateValue(resultAll!.STEP4_RASInhibitor!.rasName!.lowercased(), forKey: "arb_4")
            switch resultAll?.STEP4_RASInhibitor?.rasQuestion1 {
            case true:
                parameters.updateValue("y", forKey: "arb_yn_contraindications_4")
            case false:
                parameters.updateValue("n", forKey: "arb_yn_contraindications_4")
            default :
                break
            }
            switch resultAll?.STEP4_RASInhibitor?.rasQuestion2 {
            case true:
                parameters.updateValue("y", forKey: "arb_yn_patient_4")
            case false:
                parameters.updateValue("n", forKey: "arb_yn_patient_4")
            default :
                break
            }
            
        case .None:
            parameters.updateValue("none", forKey: "ras_4")
            parameters.updateValue(resultAll!.STEP4_RASInhibitor!.rasIndicateCI!, forKey: "none_acei_arb_arni_4")
            parameters.updateValue(resultAll!.STEP4_RASInhibitor!.rasIndicateCI2!, forKey: "none_acei_specifici_4")
            parameters.updateValue(resultAll!.STEP4_RASInhibitor!.rasIndicateCI3!, forKey: "none_arb_specifici_4")
        default :
            break
        }
        
        //STEP5 BETABLOCKER
        switch resultAll?.STEP5_BetaBlocker?.bbName {
        case .None:
            parameters.updateValue("none", forKey: "evidence_5")
            parameters.updateValue(resultAll!.STEP5_BetaBlocker!.bbIndicateCI!, forKey: "none_choice_5")
            
        case .Bisoprolol:
            parameters.updateValue("bisoprolol", forKey: "evidence_5")
            switch resultAll?.STEP5_BetaBlocker?.bbQuestion1 {
            case true:
                parameters.updateValue("y", forKey: "bisoprolol_yn1_5")
            case false:
                parameters.updateValue("n", forKey: "bisoprolol_yn1_5")
            default :
                break
            }
            switch resultAll?.STEP5_BetaBlocker?.bbQuestion2 {
            case true:
                parameters.updateValue("y", forKey: "bisoprolol_yn2_5")
            case false:
                parameters.updateValue("n", forKey: "bisoprolol_yn2_5")
            default :
                break
            }
            
        case .Carvedilol:
            parameters.updateValue("carvedilol", forKey: "evidence_5")
            switch resultAll?.STEP5_BetaBlocker?.bbQuestion1 {
            case true:
                parameters.updateValue("y", forKey: "carvedilol_yn1_5")
            case false:
                parameters.updateValue("n", forKey: "carvedilol_yn1_5")
            default :
                break
            }
            switch resultAll?.STEP5_BetaBlocker?.bbQuestion2 {
            case true:
                parameters.updateValue("y", forKey: "carvedilol_yn2_5")
            case false:
                parameters.updateValue("n", forKey: "carvedilol_yn2_5")
            default :
                break
            }
            
        case .CR:
            parameters.updateValue("carvedilol_cr", forKey: "evidence_5")
            switch resultAll?.STEP5_BetaBlocker?.bbQuestion1 {
            case true:
                parameters.updateValue("y", forKey: "carvedilol_cr_yn1_5")
            case false:
                parameters.updateValue("n", forKey: "carvedilol_cr_yn1_5")
            default :
                break
            }
            switch resultAll?.STEP5_BetaBlocker?.bbQuestion2 {
            case true:
                parameters.updateValue("y", forKey: "carvedilol_cr_yn2_5")
            case false:
                parameters.updateValue("n", forKey: "carvedilol_cr_yn2_5")
            default :
                break
            }
            
        case .Metoprolol:
            parameters.updateValue("metoprolol", forKey: "evidence_5")
            switch resultAll?.STEP5_BetaBlocker?.bbQuestion1 {
            case true:
                parameters.updateValue("y", forKey: "metoprolol_yn1_5")
            case false:
                parameters.updateValue("n", forKey: "metoprolol_yn1_5")
            default :
                break
            }
            switch resultAll?.STEP5_BetaBlocker?.bbQuestion2 {
            case true:
                parameters.updateValue("y", forKey: "metoprolol_yn2_5")
            case false:
                parameters.updateValue("n", forKey: "metoprolol_yn2_5")
            default :
                break
            }
            
        default :
            break
        }
        
        //STEP6 ADDITIONAL MED
        parameters.updateValue(resultAll!.STEP6_AdditionalMedicine!, forKey: "additionnal_6")
        
        //STEP7 DIURETIC
        switch resultAll?.STEP7_Diuretics {
        case true:
            parameters.updateValue("y", forKey: "diuretic_7")
        case false:
            parameters.updateValue("n", forKey: "diuretic_7")
        default :
            break
        }
        
        //STEP8 ADDITIONAL MED
        if resultAll?.STEP2_NYHA == .Class2 || resultAll?.STEP2_NYHA == .Class3 || resultAll?.STEP2_NYHA == .Class4 {
            parameters.updateValue(resultAll!.STEP8_Indication!.therapiesIndication!, forKey: "further_8")
            parameters.updateValue(resultAll!.STEP8_Indication!.dosingIndication!, forKey: "further2_8")
        }
        
        print(parameters)
        
        loadRequest(method:.post, apiName:"NewGuideline", authorization:false, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS RESULT\(json)")
                
                self.resultJSON = json["data"]
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension Assessment_Result: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (resultJSON != nil) {
            return 10
        }
        else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
//        let cornerRadius = 15
//        var corners: UIRectCorner = []
//
//        if indexPath.row == 0
//        {
//            corners.update(with: .topLeft)
//            corners.update(with: .topRight)
//        }
//
//        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
//        {
//            corners.update(with: .bottomLeft)
//            corners.update(with: .bottomRight)
//        }
//
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = UIBezierPath(roundedRect: cell.bounds,
//                                      byRoundingCorners: corners,
//                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
//        cell.layer.mask = maskLayer
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestCell", for: indexPath) as! SuggestCell
        
        let hideSeperator = UIEdgeInsets.init(top: 0, left: 400,bottom: 0, right: 0)
        
        cell.cellHeadTitle.text = "คำแนะนำจาก Step \(indexPath.row+1)"
        cell.cellTitle1.text = "ACEI (Captopril):"
        cell.cellDetail1.text = "ปริมาณเหมาะสมที่แนะนำ (target dose): 50 มิลลิกรัม 3x ต่อวันพิจารณาเพิ่มปริมาณ (dose) อย่างน้อยครั้งละ 2 สัปดาห์จนกว่าผู้ป่วยจะทนต่อยาไม่ไหว (tolerated) หรือ ผู้ป่วยได้รับยาในประมาณที่เหมาะสมตามคำแนะนำแล้ว (target dose)\nRAS inhibitors แนะนำให้ใช้ในกลุ่มผู้ป่วยที่มี NYHA ระหว่าง II-IV และยังไม่มีข้อแนะนำสำหรับการนำมาใช้ในกลุ่มผู้ป่วย NYHA I หรือ unknown แนะนำให้ใช้ดุลพินิจทางการแพทย์ในการนำยามาใช้กับ ผู้ป่วยกลุ่มนี้"
        cell.cellTitle2.text = "ACEI (Captopril):"
        cell.cellDetail2.text = "ปริมาณเหมาะสมที่แนะนำ (target dose): 50 มิลลิกรัม 3x ต่อวันพิจารณาเพิ่มปริมาณ (dose) อย่างน้อยครั้งละ 2 สัปดาห์จนกว่าผู้ป่วยจะทนต่อยาไม่ไหว (tolerated) หรือ ผู้ป่วยได้รับยาในประมาณที่เหมาะสมตามคำแนะนำแล้ว (target dose)\nRAS inhibitors แนะนำให้ใช้ในกลุ่มผู้ป่วยที่มี NYHA ระหว่าง II-IV และยังไม่มีข้อแนะนำสำหรับการนำมาใช้ในกลุ่มผู้ป่วย NYHA I หรือ unknown แนะนำให้ใช้ดุลพินิจทางการแพทย์ในการนำยามาใช้กับ ผู้ป่วยกลุ่มนี้"
        
        if indexPath.row == 0 {
            cell.cellTitle2.isHidden = true
            cell.cellDetail2.isHidden = true
        }
        else if indexPath.row == 2 {
            cell.cellTitle2.isHidden = true
            cell.cellDetail2.isHidden = true
            
            cell.separatorInset = hideSeperator
        }
        else{
            cell.cellTitle2.isHidden = false
            cell.cellDetail2.isHidden = false
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension Assessment_Result: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
