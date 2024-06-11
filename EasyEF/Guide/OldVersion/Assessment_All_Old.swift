////
////  Assessment_All.swift
////  EasyEF
////
////  Created by Truk Karawawattana on 3/4/2567 BE.
////
//
//import UIKit
//
//struct step1 {
//    var name: String?
//    var value: LVEF?
//}
//
//struct step2 {
//    var name: String?
//    var value: NYHA?
//}
//
//struct step3 {
//    var name: String?
//    var value: LVEF_Med?
//    var value2: LVEF_Med_Class?
//}
//
//struct step5 {
//    var name: String?
//    var value: BetaBlocker?
//    var question: String?
//}
//
//class Assessment_All: UIViewController, UITextFieldDelegate {
//    
//    var resultAll = ResultAll()
//    
//    let trueFalse_Array = [true, false]
//    let countryStr = " (ยาในบัญชียาหลักแห่งชาติ)"
//    
//    var step1_checked = false
//    var step2_checked = false
//    var step3_checked = false
//    var step4_checked = false
//    var step5_checked = false
//    var step6_checked = false
//    var step7_checked = false
//    
//    @IBOutlet weak var myScrollView: UIScrollView!
//    @IBOutlet weak var submitBtn: UIButton!
//    
//    // MARK: - Step 1
//    @IBOutlet weak var step1_Field: UITextField!
//    @IBOutlet weak var step1_Dropdown: UIButton!
//    var step1_Picker: UIPickerView! = UIPickerView()
//    
//    let step1_Array = [step1(name: "Reduced (≤40%)", value: .Reduced),
//                       step1(name: "Mildly reduced (41-49%)", value: .Mildly),
//                       step1(name: "Preserved (≥50%)", value: .Preserved),
//    ]
//    
//    // MARK: - Step 2
//    //    @IBOutlet weak var step2_Btn_info: UIButton!
//    //    @IBOutlet weak var step2_infoLabel: UILabel!
//    @IBOutlet weak var step2_Field: UITextField!
//    @IBOutlet weak var step2_Dropdown: UIButton!
//    var step2_Picker: UIPickerView! = UIPickerView()
//    
//    let step2_Array = [step2(name: "Class I", value: .Class1),
//                       step2(name: "Class II", value: .Class2),
//                       step2(name: "Class III", value: .Class3),
//                       step2(name: "Class IV", value: .Class4),
//                       step2(name: "Unknow", value: .ClassUnknow),
//    ]
//    
//    // MARK: - Step 3
//    @IBOutlet weak var step3_Btn_info: UIButton!
//    @IBOutlet weak var step3_infoView: UIImageView!
//    @IBOutlet weak var step3_Btn_SGLT2i: UIButton!
//    @IBOutlet weak var step3_Btn_MRA: UIButton!
//    @IBOutlet weak var step3_Btn_RASi_ARNI: UIButton!
//    @IBOutlet weak var step3_Btn_BB: UIButton!
//    
//    let step3_Array_Reduce = [step3(name: "SGLT2i", value: .SGLT2i, value2: .Ia),
//                              step3(name: "MRA", value: .MRA, value2: .Ia),
//                              step3(name: "RASi/ARNI", value: .RASi_ARNI, value2: .Ia),
//                              step3(name: "BB", value: .BB, value2: .Ia)
//    ]
//    
//    let step3_Array_Mildly = [step3(name: "SGLT2i", value: .SGLT2i, value2: .Ia),
//                              step3(name: "MRA", value: .MRA, value2: .IIa),
//                              step3(name: "RASi/ARNI", value: .RASi_ARNI, value2: .IIb),
//                              step3(name: "BB", value: .BB, value2: .IIb)
//    ]
//    
//    let step3_Array_Preserve = [step3(name: "SGLT2i", value: .SGLT2i, value2: .Ia),
//                                step3(name: "MRA", value: .MRA, value2: .IIa),
//                                step3(name: "RASi/ARNI", value: .RASi_ARNI, value2: .IIb),
//    ]
//    
//    var step3_Array_Selected = [step3]()
//    
//    // MARK: - Step 4
//    @IBOutlet weak var step4_Btn_ARNI: UIButton!
//    @IBOutlet weak var step4_Btn_ACEI: UIButton!
//    @IBOutlet weak var step4_Btn_ARB: UIButton!
//    @IBOutlet weak var step4_Btn_NONE: UIButton!
//    
//    @IBOutlet weak var step4_Stack_ACEI: UIStackView!
//    @IBOutlet weak var step4_Field_ACEI: UITextField!
//    @IBOutlet weak var step4_Dropdown_ACEI: UIButton!
//    @IBOutlet weak var step4_Btn_ACEI_Yes1: UIButton!
//    @IBOutlet weak var step4_Btn_ACEI_No1: UIButton!
//    @IBOutlet weak var step4_Btn_ACEI_Yes2: UIButton!
//    @IBOutlet weak var step4_Btn_ACEI_No2: UIButton!
//    var step4_Picker_ACEI: UIPickerView! = UIPickerView()
//    
//    @IBOutlet weak var step4_Stack_ARB: UIStackView!
//    @IBOutlet weak var step4_Field_ARB: UITextField!
//    @IBOutlet weak var step4_Dropdown_ARB: UIButton!
//    @IBOutlet weak var step4_Btn_ARB_Yes1: UIButton!
//    @IBOutlet weak var step4_Btn_ARB_No1: UIButton!
//    @IBOutlet weak var step4_Btn_ARB_Yes2: UIButton!
//    @IBOutlet weak var step4_Btn_ARB_No2: UIButton!
//    var step4_Picker_ARB: UIPickerView! = UIPickerView()
//    
//    @IBOutlet weak var step4_Stack_None: UIStackView!
//    @IBOutlet weak var step4_Btn_None: UIButton!
//    
//    let step4_Array_Main:[RASInhibitor] = [.ARNI,
//                                           .ACEI,
//                                           .ARB,
//                                           .None
//    ]
//    
//    let step4_Array_ACEI = ["Captopril",
//                            "Enalapril",
//                            "Lisinopril",
//                            "Fosinopril",
//                            "Perindopril",
//                            "Quinapril",
//                            "Ramipril",
//                            "Trandolapril",
//    ]
//    
//    let step4_Array_ARB = ["Candesartan",
//                           "Losartan",
//                           "Valsartan",
//    ]
//    
//    let step4_Array_CI = ["ไม่มี",
//                          "ผู้ป่วยเบาหวานที่ใช้ยา Aliskiren",
//                          "หญิงตั้งครรภ์",
//                          "มีประวัติ ภาวะภูมิไว (Hypersensitivity) กับ ACEI",
//                          "มีประวัติเนื้อเยื่อบวมจากการแพ้ (Angioedema)",
//                          "ไอ (ผลข้างเคียงทั่วไปที่เกิดจาก ACEI)",
//                          "มีประวัติ ภาวะภูมิไว (Hypersensitivity) กับ ARB",
//    ]
//    
//    // MARK: - Step 5
//    @IBOutlet weak var step5_Field: UITextField!
//    @IBOutlet weak var step5_Dropdown: UIButton!
//    @IBOutlet weak var step5_Stack_Question: UIStackView!
//    @IBOutlet weak var step5_Question1: UILabel!
//    @IBOutlet weak var step5_Btn_Yes1: UIButton!
//    @IBOutlet weak var step5_Btn_No1: UIButton!
//    @IBOutlet weak var step5_Btn_Yes2: UIButton!
//    @IBOutlet weak var step5_Btn_No2: UIButton!
//    var step5_Picker: UIPickerView! = UIPickerView()
//    
//    @IBOutlet weak var step5_Stack_None: UIStackView!
//    @IBOutlet weak var step5_Btn_None: UIButton!
//    
//    let step5_QuestionStr = "1. ผู้ป่วยอยู่ในสภาวะทนต่อปริมาณ beta blocker ได้ถึงจุดสูงสุด (maximally) หรือไม่? \nและมีอัตราการเต้นหัวใจที่  ≥ 70 bpm หรือไม่? \n\n"
//    let step5_Array_Main = [step5(name: "Carvedilol (ยาในบัญชียาหลักแห่งชาติ)",value: .Carvedilol,question: "(ปริมาณแนะนำที่เหมาะสมของ carvedilol : 25 มิลลิกรัม 2 ครั้งต่อวัน สำหรับน้ำหนัก <85 กิโลกรัม และ 50 มิลลิกรัม 2 ครั้งต่อวัน สำหรับน้ำหนัก ≥85 กิโลกรัม)"),
//                            step5(name: "Bisoprolol",value: .Bisoprolol,question: "(ปริมาณแนะนำที่เหมาะสมของ bisoprolol : 10 มิลลิกรัม ต่อวัน)"),
//                            step5(name: "Nebivolol",value: .Nebivolol,question: "(ปริมาณแนะนำที่เหมาะสมของ nebivolol : 10 มิลลิกรัม ต่อวัน)"),
//                            step5(name: "Metoprolol Succinate extended release (metoprolol CR/XL)",value: .Metoprolol,question: "(ปริมาณแนะนำที่เหมาะสมของ metoprolol CR/XL : 200 มิลลิกรัม ต่อวัน)"),
//                            step5(name: "None",value: .None,question: ""),
//    ]
//    
//    let step5_Array_CI = ["ไม่มี",
//                          "ภาวะภูมิไว (hypersensitivity) ต่อปัจจัยใดก็ได้",
//                          "ภาวะช็อกจากระบบไหลเวียนโลหิตหัวใจ (cardiogenic shock)",
//                          "Second or third degree AV block",
//                          "ภาวะหัวใจเต้นช้ารุนแรง (severe bradycardia) (นอกจากใส่เครื่องกระตุ้นไฟฟ้าหัวใจ)",
//                          "โรคปมไฟฟ้าหัวใจเสื่อม (sick sinus syndrome)",
//                          "Decompensated cardiac failure",
//                          "Severe hepatic impairment",
//                          "Symptomatic hypotension",
//                          "โรคเลือดส่วนปลายอุดตันรุนแรง (severe forms of peripheral arterial occlusive disease) หรือ โรคเรเนาด์ (raynaud syndrome)",
//                          "เนื้องอกต่อมหมวกไต (adrenal gland tumors) ที่ยังไม่ได้รักษา หรือ เนื้องอกต่อมหมวกไตชนิดฟีโอโครโมไซโตมา (phaeochromocytoma)",
//    ]
//    
//    // MARK: - Step 6
//    @IBOutlet weak var step6_Stack_None: UIStackView!
//    @IBOutlet weak var step6_Btn_None: UIButton!
//    
//    // MARK: - Step 7
//    @IBOutlet weak var step7_Btn_Yes: UIButton!
//    @IBOutlet weak var step7_Btn_No: UIButton!
//    
//    // MARK: - Step 8
//    @IBOutlet weak var step8_Stack_Main: UIStackView!
//    @IBOutlet weak var step8_Stack_None: UIStackView!
//    
//    @IBOutlet weak var step8_Btn_1_1: UIButton!
//    @IBOutlet weak var step8_Btn_1_2: UIButton!
//    @IBOutlet weak var step8_Btn_2_2: UIButton!
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.navigationController?.setStatusBar(backgroundColor: .themeColor)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("ASSESSMENT ALL")
//        
//        myScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
//        
//        submitBtn.disableBtn()
//        
//        setupFieldWithPicker(step1_Field, step1_Picker)
//        setupFieldWithPicker(step2_Field, step2_Picker)
//        
//        step3_infoView.isHidden = true
//        step3_Btn_SGLT2i.isUserInteractionEnabled = false
//        step3_Btn_MRA.isUserInteractionEnabled = false
//        step3_Btn_RASi_ARNI.isUserInteractionEnabled = false
//        step3_Btn_BB.isUserInteractionEnabled = false
//        step3_ButtonClear()
//        
//        setupFieldWithPicker(step4_Field_ACEI, step4_Picker_ACEI)
//        setupFieldWithPicker(step4_Field_ARB, step4_Picker_ARB)
//        step4_ResetAll()
//        
//        setupFieldWithPicker(step5_Field, step5_Picker)
//        step5_ResetAll()
//        
//        step6_ResetAll()
//        
//        step7_ResetAll()
//        
//        step8_ResetAll()
//    }
//    
//    func setupFieldWithPicker(_ textField:UITextField, _ picker:UIPickerView) {
//        textField.delegate = self
//        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
//                            for: .editingChanged)
//        
//        picker.delegate = self
//        picker.dataSource = self
//        picker.backgroundColor = .white
//        picker.setValue(UIColor.textDarkGray, forKeyPath: "textColor")
//        
//        textField.inputView = picker
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        // MARK: - Step 1
//        if textField == step1_Field && step1_Field.text == "" {
//            selectPicker(step1_Picker, didSelectRow: 0)
//        }
//        // MARK: - Step 2
//        else if textField == step2_Field && step2_Field.text == "" {
//            selectPicker(step2_Picker, didSelectRow: 0)
//        }
//        // MARK: - Step 4
//        else if textField == step4_Field_ACEI && step4_Field_ACEI.text == "" {
//            selectPicker(step4_Picker_ACEI, didSelectRow: 0)
//        }
//        else if textField == step4_Field_ARB && step4_Field_ARB.text == "" {
//            selectPicker(step4_Picker_ARB, didSelectRow: 0)
//        }
//        // MARK: - Step 5
//        else if textField == step5_Field && step5_Field.text == "" {
//            selectPicker(step5_Picker, didSelectRow: 0)
//        }
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        //        checkAll()
//    }
//    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        //        checkAll()
//    }
//    
//    @IBAction func dropdownClick(_ sender: UIButton) {
//        // MARK: - Step 1
//        if sender == step1_Dropdown {
//            step1_Field.becomeFirstResponder()
//        }
//        // MARK: - Step 2
//        else if sender == step2_Dropdown {
//            step2_Field.becomeFirstResponder()
//        }
//        // MARK: - Step 4
//        else if sender == step4_Dropdown_ACEI {
//            step4_Field_ACEI.becomeFirstResponder()
//        }
//        else if sender == step4_Dropdown_ARB {
//            step4_Field_ARB.becomeFirstResponder()
//        }
//        // MARK: - Step 5
//        else if sender == step5_Dropdown {
//            step5_Field.becomeFirstResponder()
//        }
//    }
//    
//    @IBAction func submitClick(_ sender: UIButton) {
//        print("DONE 8\n\(String(describing: resultAll))\n")
//        
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Assessment_Web") as! Assessment_Web
//        vc.resultAll = resultAll
//        self.navigationController!.pushViewController(vc, animated: true)
//    }
//    
//    @IBAction func back(_ sender: UIButton) {
//        self.navigationController!.popViewController(animated: true)
//    }
//}
//
//// MARK: - Picker Datasource
//extension Assessment_All: UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        // MARK: - Step 1
//        if pickerView == step1_Picker {
//            return step1_Array.count
//        }
//        // MARK: - Step 2
//        else if pickerView == step2_Picker {
//            return step2_Array.count
//        }
//        // MARK: - Step 4
//        else if pickerView == step4_Picker_ACEI {
//            return step4_Array_ACEI.count
//        }
//        else if pickerView == step4_Picker_ARB {
//            return step4_Array_ARB.count
//        }
//        // MARK: - Step 5
//        else if pickerView == step5_Picker {
//            return step5_Array_Main.count
//        }
//        else{
//            return 0
//        }
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        // MARK: - Step 1
//        if pickerView == step1_Picker {
//            return step1_Array[row].name
//        }
//        // MARK: - Step 2
//        else if pickerView == step2_Picker {
//            return step2_Array[row].name
//        }
//        // MARK: - Step 4
//        else if pickerView == step4_Picker_ACEI {
//            if row <= 2 {
//                return step4_Array_ACEI[row]+countryStr
//            }
//            else{
//                return step4_Array_ACEI[row]
//            }
//        }
//        else if pickerView == step4_Picker_ARB {
//            return step4_Array_ARB[row]
//        }
//        // MARK: - Step 5
//        else if pickerView == step5_Picker {
//            return step5_Array_Main[row].name
//        }
//        else{
//            return ""
//        }
//    }
//}
//
//// MARK: - Picker Delegate
//extension Assessment_All: UIPickerViewDelegate {
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
//    {
//        //print("Select \(row)")
//        selectPicker(pickerView, didSelectRow: row)
//    }
//    
//    func selectPicker(_ pickerView: UIPickerView, didSelectRow row: Int) {
//        // MARK: - Step 1
//        if pickerView == step1_Picker {
//            step1_Field.text = step1_Array[row].name
//            resultAll.STEP1_LVEF = step1_Array[row].value
//            
//            switch resultAll.STEP1_LVEF {
//            case .Reduced:
//                step3_Array_Selected = step3_Array_Reduce
//                
//            case .Mildly:
//                step3_Array_Selected = step3_Array_Mildly
//                
//            case .Preserved:
//                step3_Array_Selected = step3_Array_Preserve
//                
//            default:
//                break
//            }
//            step3_Setup(arr: step3_Array_Selected)
//            
//            checkStep(1)
//        }
//        // MARK: - Step 2
//        else if pickerView == step2_Picker {
//            step2_Field.text = step2_Array[row].name
//            resultAll.STEP2_NYHA = step2_Array[row].value
//            
//            if resultAll.STEP2_NYHA == .Class2 || resultAll.STEP2_NYHA == .Class3 || resultAll.STEP2_NYHA == .Class4 {
//                step8_Stack_Main.isHidden = false
//            }
//            else {//Class 1 , Class Unknow
//                step8_Stack_Main.isHidden = true
//            }
//            
//            checkStep(2)
//        }
//        // MARK: - Step 4
//        else if pickerView == step4_Picker_ACEI {
//            if row <= 2 {
//                step4_Field_ACEI.text = step4_Array_ACEI[row]+countryStr
//            }
//            else{
//                step4_Field_ACEI.text = step4_Array_ACEI[row]
//            }
//            resultAll.STEP4_RASInhibitor?.rasName = step4_Array_ACEI[row]
//            
//            checkStep(4)
//        }
//        else if pickerView == step4_Picker_ARB {
//            step4_Field_ARB.text = step4_Array_ARB[row]
//            resultAll.STEP4_RASInhibitor?.rasName = step4_Array_ARB[row]
//            
//            checkStep(4)
//        }
//        // MARK: - Step 5
//        else if pickerView == step5_Picker {
//            step5_ResetAll()
//            
//            step5_Field.text = step5_Array_Main[row].name
//            resultAll.STEP5_BetaBlocker?.bbName = step5_Array_Main[row].value
//            step5_Question1.text = step5_QuestionStr+step5_Array_Main[row].question!
//            
//            if resultAll.STEP5_BetaBlocker?.bbName == .None {
//                step5_Stack_Question.isHidden = true
//                step5_Stack_None.isHidden = false
//            }
//            else {
//                step5_Stack_Question.isHidden = false
//                step5_Stack_None.isHidden = true
//            }
//            
//            checkStep(5)
//        }
//    }
//}
//
//// MARK: - Step Extension
//extension Assessment_All {
//    // MARK: - Step 3
//    func step3_Setup(arr:[step3]) {
//        step3_ButtonClear()
//        step3_ButtonSetup(btn: step3_Btn_SGLT2i, arr: arr[0])
//        step3_ButtonSetup(btn: step3_Btn_MRA, arr: arr[1])
//        step3_ButtonSetup(btn: step3_Btn_RASi_ARNI, arr: arr[2])
//        
//        if arr.count == 4 {
//            step3_Btn_BB.isHidden = false
//            step3_ButtonSetup(btn: step3_Btn_BB, arr: arr[3])
//        }
//        else {//Preserved
//            step3_Btn_BB.isHidden = true
//        }
//    }
//    
//    func step3_ButtonSetup(btn:UIButton, arr:step3) {
//        btn.setTitle(arr.name, for: .normal)
//        btn.setImage(nil, for: .normal)
//        btn.isUserInteractionEnabled = true
//        
//        switch arr.value2 {
//        case .Ia:
//            btn.backgroundColor = .class1A
//            
//        case .IIa:
//            btn.backgroundColor = .class2A
//            
//        case .IIb:
//            btn.backgroundColor = .class2B
//            
//        default:
//            break
//        }
//    }
//    
//    func step3_ButtonClear() {
//        resultAll.STEP3_LVEF_Med = LVEF_MedStruct()
//        step3_Btn_SGLT2i.setImage(nil, for: .normal)
//        step3_Btn_MRA.setImage(nil, for: .normal)
//        step3_Btn_RASi_ARNI.setImage(nil, for: .normal)
//        step3_Btn_BB.setImage(nil, for: .normal)
//    }
//    
//    @IBAction func step3_Click(_ sender: UIButton) {
//        step3_ButtonClear()
//        
//        let checkmark = UIImage(named: "checkmark")
//        sender.setImage(checkmark, for: .normal)
//        view.endEditing(true)
//        
//        resultAll.STEP3_LVEF_Med?.medGroup = step3_Array_Selected[sender.tag].value
//        resultAll.STEP3_LVEF_Med?.medClass = step3_Array_Selected[sender.tag].value2
//        
//        checkStep(3)
//    }
//    
//    @IBAction func step3_Info(_ sender: UIButton) {
//        step3_infoView.isHidden.toggle()
//    }
//    
//    // MARK: - Step 4
//    func step4_ResetAll() {
//        resultAll.STEP4_RASInhibitor = RASInhibitorStruct()
//        step4_Btn_ARNI.unselectedBtn()
//        step4_Btn_ACEI.unselectedBtn()
//        step4_Btn_ARB.unselectedBtn()
//        step4_Btn_NONE.unselectedBtn()
//        
//        step4_Stack_ACEI.isHidden = true
//        step4_Field_ACEI.text = ""
//        step4_Btn_ACEI_Yes1.unselectedBtn()
//        step4_Btn_ACEI_No1.unselectedBtn()
//        step4_Btn_ACEI_Yes2.unselectedBtn()
//        step4_Btn_ACEI_No2.unselectedBtn()
//        
//        step4_Stack_ARB.isHidden = true
//        step4_Field_ARB.text = ""
//        step4_Btn_ARB_Yes1.unselectedBtn()
//        step4_Btn_ARB_No1.unselectedBtn()
//        step4_Btn_ARB_Yes2.unselectedBtn()
//        step4_Btn_ARB_No2.unselectedBtn()
//        
//        step4_Stack_None.isHidden = true
//        clearAllCheckbox(step4_Stack_None, multipleChoice: true)
//    }
//    
//    @IBAction func step4_MainClick(_ sender: UIButton) {
//        step4_ResetAll()
//        sender.selectedBtn()
//        view.endEditing(true)
//        
//        switch sender.tag {
//        case 1:
//            step4_Stack_ACEI.isHidden = false
//            
//        case 2:
//            step4_Stack_ARB.isHidden = false
//            
//        case 3:
//            step4_Stack_None.isHidden = false
//            
//        default:
//            break
//        }
//        
//        resultAll.STEP4_RASInhibitor?.rasGroup = step4_Array_Main[sender.tag]
//        
//        checkStep(4)
//    }
//    
//    @IBAction func step4_Click_YesNo_1(_ sender: UIButton) {
//        step4_Btn_ACEI_Yes1.unselectedBtn()
//        step4_Btn_ACEI_No1.unselectedBtn()
//        
//        step4_Btn_ARB_Yes1.unselectedBtn()
//        step4_Btn_ARB_No1.unselectedBtn()
//        sender.selectedBtn()
//        view.endEditing(true)
//        
//        resultAll.STEP4_RASInhibitor?.rasQuestion1 = trueFalse_Array[sender.tag]
//        
//        checkStep(4)
//    }
//    
//    @IBAction func step4_Click_YesNo_2(_ sender: UIButton) {
//        step4_Btn_ACEI_Yes2.unselectedBtn()
//        step4_Btn_ACEI_No2.unselectedBtn()
//        
//        step4_Btn_ARB_Yes2.unselectedBtn()
//        step4_Btn_ARB_No2.unselectedBtn()
//        sender.selectedBtn()
//        view.endEditing(true)
//        
//        resultAll.STEP4_RASInhibitor?.rasQuestion2 = trueFalse_Array[sender.tag]
//        
//        checkStep(4)
//    }
//    
//    @IBAction func step4_Click_None(_ sender: UIButton) {
//        view.endEditing(true)
//        if sender.tag == 0 {//ไม่มี
//            clearAllCheckbox(step4_Stack_None, multipleChoice: true)
//            sender.setImage(UIImage.squareBoxON, for: .normal)
//            
//            resultAll.STEP4_RASInhibitor?.rasIndicateCI = []
//            resultAll.STEP4_RASInhibitor?.rasIndicateCI2 = []
//            resultAll.STEP4_RASInhibitor?.rasIndicateCI3 = []
//            resultAll.STEP4_RASInhibitor?.rasIndicateCI?.append(step4_Array_CI[0])
//        }
//        else {
//            step4_Btn_None.setImage(UIImage.squareBoxOFF, for: .normal)
//            if let noneIndex = resultAll.STEP4_RASInhibitor?.rasIndicateCI?.firstIndex(of:step4_Array_CI[0]) {
//                resultAll.STEP4_RASInhibitor?.rasIndicateCI?.remove(at: noneIndex)
//            }
//            
//            if sender.tag >= 1 && sender.tag <= 2 {//อื่นๆ
//                if sender.imageView?.image == UIImage.squareBoxON {
//                    sender.setImage(UIImage.squareBoxOFF, for: .normal)
//                    if let index = resultAll.STEP4_RASInhibitor?.rasIndicateCI?.firstIndex(of:step4_Array_CI[sender.tag]) {
//                        resultAll.STEP4_RASInhibitor?.rasIndicateCI?.remove(at: index)
//                    }
//                } else {
//                    sender.setImage(UIImage.squareBoxON, for: .normal)
//                    resultAll.STEP4_RASInhibitor?.rasIndicateCI?.append(step4_Array_CI[sender.tag])
//                }
//            }
//            else if sender.tag >= 3 && sender.tag <= 5 {//อื่นๆ
//                if sender.imageView?.image == UIImage.squareBoxON {
//                    sender.setImage(UIImage.squareBoxOFF, for: .normal)
//                    if let index = resultAll.STEP4_RASInhibitor?.rasIndicateCI2?.firstIndex(of:step4_Array_CI[sender.tag]) {
//                        resultAll.STEP4_RASInhibitor?.rasIndicateCI2?.remove(at: index)
//                    }
//                } else {
//                    sender.setImage(UIImage.squareBoxON, for: .normal)
//                    resultAll.STEP4_RASInhibitor?.rasIndicateCI2?.append(step4_Array_CI[sender.tag])
//                }
//            }
//            else if sender.tag >= 6 && sender.tag <= 6 {//อื่นๆ
//                if sender.imageView?.image == UIImage.squareBoxON {
//                    sender.setImage(UIImage.squareBoxOFF, for: .normal)
//                    if let index = resultAll.STEP4_RASInhibitor?.rasIndicateCI3?.firstIndex(of:step4_Array_CI[sender.tag]) {
//                        resultAll.STEP4_RASInhibitor?.rasIndicateCI3?.remove(at: index)
//                    }
//                } else {
//                    sender.setImage(UIImage.squareBoxON, for: .normal)
//                    resultAll.STEP4_RASInhibitor?.rasIndicateCI3?.append(step4_Array_CI[sender.tag])
//                }
//            }
//        }
//        checkStep(4)
//    }
//    
//    func clearAllCheckbox(_ view: UIView, multipleChoice: Bool = false) {
//        for mainStack in view.subviews as [UIView] {//Main
//            for subStack in mainStack.subviews as [UIView] {//Sub
//                for view in subStack.subviews as [UIView] {
//                    if let btn = view as? UIButton {
//                        if !multipleChoice {
//                            btn.setImage(UIImage.circleBoxOFF, for: .normal)
//                        }
//                        else {
//                            btn.setImage(UIImage.squareBoxOFF, for: .normal)
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    // MARK: - Step 5
//    func step5_ResetAll() {
//        resultAll.STEP5_BetaBlocker = BetaBlockerStruct()
//        step5_Btn_Yes1.unselectedBtn()
//        step5_Btn_No1.unselectedBtn()
//        
//        step5_Btn_Yes2.unselectedBtn()
//        step5_Btn_No2.unselectedBtn()
//        
//        step5_Stack_Question.isHidden = true
//        step5_Stack_None.isHidden = true
//        
//        clearAllCheckbox(step5_Stack_None, multipleChoice: true)
//    }
//    
//    @IBAction func step5_Click_YesNo_1(_ sender: UIButton) {
//        step5_Btn_Yes1.unselectedBtn()
//        step5_Btn_No1.unselectedBtn()
//        sender.selectedBtn()
//        view.endEditing(true)
//        
//        resultAll.STEP5_BetaBlocker?.bbQuestion1 = trueFalse_Array[sender.tag]
//        
//        checkStep(5)
//    }
//    
//    @IBAction func step5_Click_YesNo_2(_ sender: UIButton) {
//        step5_Btn_Yes2.unselectedBtn()
//        step5_Btn_No2.unselectedBtn()
//        sender.selectedBtn()
//        view.endEditing(true)
//        
//        resultAll.STEP5_BetaBlocker?.bbQuestion2 = trueFalse_Array[sender.tag]
//        
//        checkStep(5)
//    }
//    
//    @IBAction func step5_Click_None(_ sender: UIButton) {
//        view.endEditing(true)
//        if sender.tag == 0 {//ไม่มี
//            clearAllCheckbox(step5_Stack_None, multipleChoice: true)
//            sender.setImage(UIImage.squareBoxON, for: .normal)
//            
//            resultAll.STEP5_BetaBlocker?.bbIndicateCI = []
//            resultAll.STEP5_BetaBlocker?.bbIndicateCI?.append(step5_Array_CI[0])
//        }
//        else {
//            step5_Btn_None.setImage(UIImage.squareBoxOFF, for: .normal)
//            if let noneIndex = resultAll.STEP5_BetaBlocker?.bbIndicateCI?.firstIndex(of:step5_Array_CI[0]) {
//                resultAll.STEP5_BetaBlocker?.bbIndicateCI?.remove(at: noneIndex)
//            }
//            
//            if sender.imageView?.image == UIImage.squareBoxON {
//                sender.setImage(UIImage.squareBoxOFF, for: .normal)
//                if let index = resultAll.STEP5_BetaBlocker?.bbIndicateCI?.firstIndex(of:step5_Array_CI[sender.tag]) {
//                    resultAll.STEP5_BetaBlocker?.bbIndicateCI?.remove(at: index)
//                }
//            } else {
//                sender.setImage(UIImage.squareBoxON, for: .normal)
//                resultAll.STEP5_BetaBlocker?.bbIndicateCI?.append(step5_Array_CI[sender.tag])
//            }
//        }
//        checkStep(5)
//    }
//    
//    // MARK: - Step 6
//    func step6_ResetAll() {
//        resultAll.STEP6_AdditionalMedicine = ["0","0","0"]
//        clearAllCheckbox(step6_Stack_None, multipleChoice: true)
//    }
//    
//    @IBAction func step6_Click(_ sender: UIButton) {
//        view.endEditing(true)
//        if sender.tag >= 0 && sender.tag <= 1  {//อื่นๆ
//            step6_Btn_None.setImage(UIImage.squareBoxOFF, for: .normal)
//            resultAll.STEP6_AdditionalMedicine?[2] = "0"
//            
//            if sender.imageView?.image == UIImage.squareBoxON {
//                sender.setImage(UIImage.squareBoxOFF, for: .normal)
//                resultAll.STEP6_AdditionalMedicine?[sender.tag] = "0"
//            } else {
//                sender.setImage(UIImage.squareBoxON, for: .normal)
//                resultAll.STEP6_AdditionalMedicine?[sender.tag] = "1"
//            }
//        }
//        else if sender.tag == 2 {//ไม่มี
//            clearAllCheckbox(step6_Stack_None, multipleChoice: true)
//            sender.setImage(UIImage.squareBoxON, for: .normal)
//            
//            resultAll.STEP6_AdditionalMedicine? = ["0","0","1"]
//        }
//        checkStep(6)
//    }
//    
//    // MARK: - Step 7
//    func step7_ResetAll() {
//        resultAll.STEP7_Diuretics = nil
//        
//        step7_Btn_Yes.unselectedBtn()
//        step7_Btn_No.unselectedBtn()
//    }
//    
//    @IBAction func step7_Click(_ sender: UIButton) {
//        step7_Btn_Yes.unselectedBtn()
//        step7_Btn_No.unselectedBtn()
//        sender.selectedBtn()
//        view.endEditing(true)
//        
//        resultAll.STEP7_Diuretics = trueFalse_Array[sender.tag]
//        
//        checkStep(7)
//    }
//    
//    // MARK: - Step 8
//    func step8_ResetAll() {
//        resultAll.STEP8_Indication = IndicationStruct()
//        resultAll.STEP8_Indication?.therapiesIndication = ["0","0","0","0","0","0"]
//        resultAll.STEP8_Indication?.dosingIndication = ["0","0","0","0","0","0"]
//        clearAllCheckbox(step8_Stack_None , multipleChoice: true)
//        
//        step8_Stack_Main.isHidden = true
//    }
//    
//    @IBAction func step8_Click_Therapies(_ sender: UIButton) {
//        view.endEditing(true)
//        if sender.imageView?.image == UIImage.squareBoxON {
//            sender.setImage(UIImage.squareBoxOFF, for: .normal)
//            resultAll.STEP8_Indication?.therapiesIndication?[sender.tag] = "0"
//        } else {
//            sender.setImage(UIImage.squareBoxON, for: .normal)
//            resultAll.STEP8_Indication?.therapiesIndication?[sender.tag] = "1"
//            step8_Special(sender)
//        }
//        checkStep(8)
//    }
//    
//    @IBAction func step8_Click_Dosing(_ sender: UIButton) {
//        if sender.imageView?.image == UIImage.squareBoxON {
//            sender.setImage(UIImage.squareBoxOFF, for: .normal)
//            resultAll.STEP8_Indication?.dosingIndication?[sender.tag] = "0"
//        } else {
//            sender.setImage(UIImage.squareBoxON, for: .normal)
//            resultAll.STEP8_Indication?.dosingIndication?[sender.tag] = "1"
//            step8_Special(sender)
//        }
//        checkStep(8)
//    }
//    
//    func step8_Special(_ sender: UIButton) {
//        if sender == step8_Btn_1_1 || sender == step8_Btn_2_2 {//eGFR ≥ 30
//            step8_Btn_1_2.setImage(UIImage.squareBoxOFF, for: .normal)
//            resultAll.STEP8_Indication?.therapiesIndication?[1] = "0"
//        }
//        else if sender == step8_Btn_1_2 {//eGFR ≥ 20
//            step8_Btn_1_1.setImage(UIImage.squareBoxOFF, for: .normal)
//            resultAll.STEP8_Indication?.therapiesIndication?[0] = "0"
//            
//            step8_Btn_2_2.setImage(UIImage.squareBoxOFF, for: .normal)
//            resultAll.STEP8_Indication?.dosingIndication?[1] = "0"
//        }
//    }
//    
//    // MARK: - Check ?
//    func checkStep(_ stepNo:Int) {
//        print("Step \(stepNo)\n\(String(describing: resultAll))\n")
//        
//        step1_checked = false
//        step2_checked = false
//        step3_checked = false
//        step4_checked = false
//        step5_checked = false
//        step6_checked = false
//        step7_checked = false
//        
//        //1
//        if resultAll.STEP1_LVEF != nil {
//            step1_checked = true
//        }
//        
//        //2
//        if resultAll.STEP2_NYHA != nil {
//            step2_checked = true
//        }
//        
//        //3
//        if resultAll.STEP3_LVEF_Med?.medGroup != nil && resultAll.STEP3_LVEF_Med?.medClass != nil {
//            step3_checked = true
//        }
//        
//        //4
//        if resultAll.STEP4_RASInhibitor?.rasGroup != nil {
//            if resultAll.STEP4_RASInhibitor?.rasGroup == .ARNI {
//                step4_checked = true
//            }
//            else if resultAll.STEP4_RASInhibitor?.rasGroup == .None && (resultAll.STEP4_RASInhibitor?.rasIndicateCI != [] || resultAll.STEP4_RASInhibitor?.rasIndicateCI2 != [] || resultAll.STEP4_RASInhibitor?.rasIndicateCI3 != []) {
//                step4_checked = true
//            }
//            else {//ACEI , ARB
//                if resultAll.STEP4_RASInhibitor?.rasName != nil && resultAll.STEP4_RASInhibitor?.rasQuestion1 != nil && resultAll.STEP4_RASInhibitor?.rasQuestion2 != nil {
//                    step4_checked = true
//                }
//            }
//        }
//        
//        //5
//        if resultAll.STEP5_BetaBlocker?.bbName != nil {
//            if resultAll.STEP5_BetaBlocker?.bbName == .Carvedilol || resultAll.STEP5_BetaBlocker?.bbName == .Bisoprolol || resultAll.STEP5_BetaBlocker?.bbName == .Nebivolol || resultAll.STEP5_BetaBlocker?.bbName == .Metoprolol {
//                if resultAll.STEP5_BetaBlocker?.bbQuestion1 != nil && resultAll.STEP5_BetaBlocker?.bbQuestion2 != nil {
//                    step5_checked = true
//                }
//            }
//            else if resultAll.STEP5_BetaBlocker?.bbName == .None && resultAll.STEP5_BetaBlocker?.bbIndicateCI != [] {
//                step5_checked = true
//            }
//        }
//        
//        if resultAll.STEP6_AdditionalMedicine != ["0","0","0"] {
//            step6_checked = true
//        }
//        
//        if resultAll.STEP7_Diuretics != nil {
//            step7_checked = true
//        }
//        
//        print("1 \(step1_checked)")
//        print("2 \(step2_checked)")
//        print("3 \(step3_checked)")
//        print("4 \(step4_checked)")
//        print("5 \(step5_checked)")
//        print("6 \(step6_checked)")
//        print("7 \(step7_checked)")
//        
//        if step1_checked && step2_checked && step3_checked && step4_checked && step5_checked && step6_checked && step7_checked
//        {
//            submitBtn.enableBtnRed()
//        }
//        else {
//            submitBtn.disableBtn()
//        }
//    }
//}
//
//// MARK: - UIButton
//extension UIButton {
//    func unselectedBtn() {
//        backgroundColor = UIColor.buttonUnselect
//        setTitleColor(.textGray1, for: .normal)
//        setImage(nil, for: .normal)
//    }
//    
//    func selectedBtn() {
//        backgroundColor = UIColor.themeColor
//        setTitleColor(.white, for: .normal)
//        let checkmark = UIImage(named: "checkmark_white")
//        setImage(checkmark, for: .normal)
//    }
//}
