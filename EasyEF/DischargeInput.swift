//
//  DischargeInput.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 26/8/2565 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD
import SwiftAlertView

class DischargeInput: UIViewController, UITextFieldDelegate {
    
    var dischargeType:dischargeType?
    
    var videoID: String?
    var patientID: String?
    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var labelField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var noteField: UITextField!
    
    var datePicker: UIDatePicker! = UIDatePicker()
    
    @IBOutlet weak var submiBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DISCHARGE INPUT")
        
        setupField(idField)
        setupField(labelField)
        setupField(dateField)
        setupField(noteField)
        
        datePickerSetup(picker: datePicker)
        dateField.inputView = datePicker
        
        submiBtn.disableBtn()
        
        if patientID != "" {
            idField.text = patientID
            idField.isUserInteractionEnabled = false
        }
    }
    
    func setupField(_ textField:UITextField) {
        textField.delegate = self
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateField && dateField.text == "" {
            datePickerChanged(picker: datePicker)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForm()
    }
    
    func datePickerSetup(picker:UIDatePicker) {
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "en_US")
        //picker.minimumDate = Date()
        picker.calendar = Calendar(identifier: .gregorian)
        picker.date = Date()
        picker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        picker.setValue(false, forKey: "highlightsToday")
        picker.setValue(UIColor.white, forKeyPath: "backgroundColor")
        picker.setValue(UIColor.textDarkGray, forKeyPath: "textColor")
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        let selectDate = appStringFromDate(date: picker.date, format: "dd MMM yyyy")
        dateField.text = selectDate
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if idField.text == "888" {
//            idField.text = "1234"
//            labelField.text = "label iOS"
//            dateField.text = "1/2/34"
//            noteField.text = "test iOS"
//            submiBtn.enableBtn()
        }
        checkForm()
    }
    
    func checkForm() {
        if idField.text!.count >= 1 && labelField.text!.count >= 1 && dateField.text!.count >= 1 && noteField.text!.count >= 1 {
            submiBtn.enableBtn()
        }
        else{
            submiBtn.disableBtn()
        }
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        SwiftAlertView.show(title: "Confirm input details",
                            message: nil,
                            buttonTitles: "Cancel", "Confirm") { alert in
            //alert.backgroundColor = .yellow
            alert.titleLabel.font = .Alert_Title
            alert.messageLabel.font = .Alert_Message
            alert.cancelButtonIndex = 0
            alert.button(at: 0)?.titleLabel?.font = .Alert_Button
            alert.button(at: 0)?.setTitleColor(.buttonRed, for: .normal)
            
            alert.button(at: 1)?.titleLabel?.font = .Alert_Button
            alert.button(at: 1)?.setTitleColor(.themeColor, for: .normal)
            //            alert.buttonTitleColor = .themeColor
        }
                            .onButtonClicked { _, buttonIndex in
                                print("Button Clicked At Index \(buttonIndex)")
                                switch buttonIndex{
                                case 1:
                                    self.loadSubmit()
                                default:
                                    break
                                }
                            }
        
    }
    
    func loadSubmit() {
//        let serverDate = dateToServerString(date: datePicker.date)
//
//        let parameters:Parameters = ["id_user":SceneDelegate.GlobalVariables.userID,
//                                     "id_vdo":videoID!,
//                                     "id_patients":idField.text!,
//                                     "discharge":labelField.text!,
//                                     "date":serverDate,
//                                     "note":noteField.text!,
//        ]
//        print(parameters)
//
//        loadRequest(method:.post, apiName:"DischargeV2/dischargeForm", authorization:false, showLoadingHUD:true, dismissHUD:false, parameters: parameters){ result in
//            switch result {
//            case .failure(let error):
//                print(error)
//                ProgressHUD.dismiss()
//
//            case .success(let responseObject):
//                let json = JSON(responseObject)
//                print("SUCCESS DISCHARGE INPUT\(json)")
//
//                ProgressHUD.showSucceed(json["message"].stringValue)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // Change `2.0` to the desired number of seconds.
//                    let vc = UIStoryboard.patientStoryBoard.instantiateViewController(withIdentifier: "DischargeForm") as! DischargeForm
//                    vc.dischargeType = self.dischargeType
//                    vc.dischargeID = json["data"][0]["id_form"].stringValue
//                    self.navigationController!.pushViewController(vc, animated: true)
//                }
//            }
//        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}
