//
//  Dose.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 2/8/2566 BE.
//

import Foundation
import UIKit

struct Med {
    var medGroup: String
    var medName: Array<String>
    var medStart: Array<String>
    var medFinal: Array<String>
}

class Dose: UIViewController, UITextFieldDelegate {
    
    var imageUrlString:String?
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var doseImage: UIImageView!
    @IBOutlet weak var doseImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var medStack1: UIStackView!
    @IBOutlet weak var medField1: UITextField!
    @IBOutlet weak var medDropdown1: UIButton!
    var medPicker1: UIPickerView! = UIPickerView()
    
    @IBOutlet weak var medStack2: UIStackView!
    @IBOutlet weak var medField2: UITextField!
    @IBOutlet weak var medDropdown2: UIButton!
    var medPicker2: UIPickerView! = UIPickerView()
    
    @IBOutlet weak var medStack3: UIStackView!
    @IBOutlet weak var doseStart: UILabel!
    @IBOutlet weak var doseFinal: UILabel!
    
    var select1:Int = 0
    
    let arr = [Med(medGroup: "ACEI",
                   medName: ["Captopril (ยาในบัญชียาหลักแห่งชาติ)","Enalapril (ยาในบัญชียาหลักแห่งชาติ)","Lisinopril (ยาในบัญชียาหลักแห่งชาติ)","Ramipril"],
                   medStart: ["6.25 mg t.i.d.","2.5 mg b.i.d.","2.5 mg o.d.","1.25 mg o.d."],
                   medFinal: ["50 mg t.i.d.","20 mg b.i.d.","40 mg o.d.","10 mg o.d."]),
               
               Med(medGroup: "ARB",
                   medName: ["Candesartan","Losartan","Valsartan"],
                   medStart: ["4 mg o.d.","25 mg o.d.","40 mg b.i.d."],
                   medFinal: ["32 mg o.d.","150 mg o.d.","160 mg b.i.d."]),
               
               Med(medGroup: "ARNI",
                   medName: ["Sacubitril / Valsartan"],
                   medStart: ["50 mg b.i.d."],
                   medFinal: ["200 mg b.i.d."]),
               
               Med(medGroup: "BB",
                   medName: ["Carvedilol (ยาในบัญชียาหลักแห่งชาติ)","Bisoprolol","Metoprolol succinate","Nebivolol"],
                   medStart: ["3.125 mg b.i.d.","1.25 mg o.d.","12.5 mg o.d.","1.25 mg o.d."],
                   medFinal: ["25 mg b.i.d.","10 mg o.d.","200 mg o.d.","10 mg o.d."]),
               
               Med(medGroup: "MRA",
                   medName: ["Spironolactone (ยาในบัญชียาหลักแห่งชาติ)"],
                   medStart: ["12.5 mg o.d."],
                   medFinal: ["50 mg o.d."]),
               
               Med(medGroup: "SGLT2i",
                   medName: ["Dapagliflozin","Empagliflozin"],
                   medStart: ["10 mg o.d.","10 mg o.d."],
                   medFinal: ["10 mg o.d.","10 mg o.d."]),
               
               Med(medGroup: "If Inhibitor",
                   medName: ["Ivabradine"],
                   medStart: ["5 mg b.i.d."],
                   medFinal: ["7.5 mg b.i.d."]),
               
               Med(medGroup: "Others",
                   medName: ["Digoxin","Hydralazine","ISDN"],
                   medStart: ["0.125 mg o.d.","25 mg t.i.d.","10 mg t.i.d."],
                   medFinal: ["0.125 mg o.d.","100 mg t.i.d.","40 mg t.i.d."])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DOSE")
        
        myScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        
        doseImage.sd_setImage(with: URL(string:imageUrlString ?? "https://echo.tmadigital.com/img/app/dose_profile.png"),
                               placeholderImage: nil,
                               completed: { (image, error, cacheType, url) in
            guard image != nil else {
                return
            }
            let ratio = image!.size.width / image!.size.height
            let newHeight = self.myScrollView.frame.width / ratio
            print(newHeight)
            self.doseImageHeight.constant = newHeight
        })
        
        setupField(medField1)
        setupPicker(medPicker1)
        medField1.inputView = medPicker1
        
        setupField(medField2)
        setupPicker(medPicker2)
        medField2.inputView = medPicker2
        medStack2.isHidden = true
        
        medStack3.isHidden = true
        
        print(arr)
    }
    
    func setupField(_ textField:UITextField) {
        textField.delegate = self
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
    }
    
    func setupPicker(_ picker:UIPickerView) {
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        picker.setValue(UIColor.textDarkGray, forKeyPath: "textColor")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == medField1 && medField1.text == "" {
            selectPicker(medPicker1, didSelectRow: 0)
        }
        if textField == medField2 && medField2.text == "" {
            selectPicker(medPicker2, didSelectRow: 0)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        checkForm()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
//        checkForm()
    }
    
    func checkForm() {
//        if passField.text!.count >= 3 {
//            checkMark(passCheck, isRight: true)
//        } else { checkMark(passCheck, isRight: false) }
    }
    
    @IBAction func dropdownClick(_ sender: UIButton) {
        if sender.tag == 1 {
            medField1.becomeFirstResponder()
        }
        if sender.tag == 2 {
            medField2.becomeFirstResponder()
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}

// MARK: - Picker Datasource
extension Dose: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == medPicker1 {
            return arr.count
        }
        else if pickerView == medPicker2 {
            return arr[select1].medName.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == medPicker1 {
            return arr[row].medGroup
        }
        else if pickerView == medPicker2 {
            return arr[select1].medName[row]
        }
        else{
            return ""
        }
    }
}

// MARK: - Picker Delegate
extension Dose: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //print("Select \(row)")
        selectPicker(pickerView, didSelectRow: row)
    }
    
    func selectPicker(_ pickerView: UIPickerView, didSelectRow row: Int) {
        if pickerView == medPicker1 {
            select1 = row
            medField1.text = arr[row].medGroup
            
            medField2.text = ""
            medPicker2.reloadAllComponents()
            medPicker2.selectRow(0, inComponent: 0, animated: true)
            medStack2.isHidden = false
            
            doseStart.text = "-"
            doseFinal.text = "-"
            medStack3.isHidden = true
        }
        else if pickerView == medPicker2 {
            medField2.text = arr[select1].medName[row]
            medPicker2.reloadAllComponents()
            
            doseStart.text = arr[select1].medStart[row]
            doseFinal.text = arr[select1].medFinal[row]
            medStack3.isHidden = false
        }
    }
}
