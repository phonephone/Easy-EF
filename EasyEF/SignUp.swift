//
//  SignUp.swift
//  AZ-Echo
//
//  Created by Truk Karawawattana on 14/7/2565 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD
import SwiftAlertView
import SearchTextField

class SignUp: UIViewController, UITextFieldDelegate {
    
    var hospitalJSON:JSON?
    var specialJSON:JSON?
    var jobJSON:JSON?
    
    var hospitalID = ""
    var specialID = ""
    var jobID = ""
    
    var mailChecked = false
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameCheck: UIImageView!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailCheck: UIImageView!
    @IBOutlet weak var emailAlert: UILabel!
    
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var passCheck: UIImageView!
    @IBOutlet weak var passShowHide: UIButton!
    
    @IBOutlet weak var hospitalField: SearchTextField!//UITextField!
    @IBOutlet weak var hospitalCheck: UIImageView!
    
    @IBOutlet weak var jobField: UITextField!
    @IBOutlet weak var jobCheck: UIImageView!
    
    @IBOutlet weak var specialField: UITextField!
    @IBOutlet weak var specialCheck: UIImageView!
    
    @IBOutlet weak var licenseField: UITextField!
    @IBOutlet weak var licenseCheck: UIImageView!
    
    @IBOutlet weak var submiBtn: UIButton!
    
    var hospitalPicker: UIPickerView! = UIPickerView()
    var specialPicker: UIPickerView! = UIPickerView()
    var jobPicker: UIPickerView! = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passShowHide.imageView?.contentMode = .scaleAspectFit
        
        setupField(nameField)
        setupField(emailField)
        setupField(passField)
        setupField(hospitalField)
        setupField(jobField)
        setupField(specialField)
        setupField(licenseField)
        
        checkMark(nameCheck, isRight: false)
        checkMark(emailCheck, isRight: false)
        checkMark(passCheck, isRight: false)
        checkMark(hospitalCheck, isRight: false)
        checkMark(jobCheck, isRight: false)
        checkMark(specialCheck, isRight: false)
        checkMark(licenseCheck, isRight: false)
        
        setupPicker(hospitalPicker)
        //hospitalField.inputView = hospitalPicker
        
        hospitalField.theme = SearchTextFieldTheme.lightTheme()
        hospitalField.theme.font = UIFont.Roboto_Regular(ofSize: 16)
        hospitalField.theme.bgColor = UIColor (red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        hospitalField.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        hospitalField.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        hospitalField.theme.cellHeight = 45

        //hospitalField.filterStrings(["Red", "Blue", "Yellow"])
        hospitalField.startVisible = true
        
        hospitalField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition] as! MySearchTextFieldItem
            print("Item at position \(itemPosition): \(String(describing: item.id)) \(item.title)")

            self.hospitalField.text = item.title
            self.hospitalID = item.id!
            self.checkForm()
        }
        
        setupPicker(specialPicker)
        specialField.inputView = specialPicker
        
        setupPicker(jobPicker)
        jobField.inputView = jobPicker
        
        emailAlert.isHidden = true
        submiBtn.disableBtn()
        
        loadHospital()
        loadSpecial()
        loadJob()
    }
    
    func loadHospital() {
        let parameters:Parameters = [:]
        loadRequest(method:.get, apiName:"Hospital", authorization:false, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                //print("SUCCESS HOSPITAL\(json)")
                
                self.hospitalJSON = json["data"]
                self.hospitalPicker.reloadAllComponents()
                self.setupHospitalArray()
            }
        }
    }
    
    func setupHospitalArray() {
        var hospitalArray:[MySearchTextFieldItem] = []
        for item in hospitalJSON! {
            //print(item.1["hospital_name"])
            let hospital = MySearchTextFieldItem(title: item.1["hospital_name"].stringValue, subtitle: nil, id: item.1["hospital_id"].stringValue)
            hospitalArray.append(hospital)
        }
        hospitalField.filterItems(hospitalArray)
    }
    
    func loadSpecial() {
        let parameters:Parameters = [:]
        loadRequest(method:.get, apiName:"Specialty", authorization:false, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                //print("SUCCESS SPECIAL\(json)")
                
                self.specialJSON = json["data"]
                self.specialPicker.reloadAllComponents()
            }
        }
    }
    
    func loadJob() {
        let parameters:Parameters = [:]
        loadRequest(method:.get, apiName:"JobTitle", authorization:false, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                //print("SUCCESS JOB\(json)")
                
                self.jobJSON = json["data"]
                self.jobPicker.reloadAllComponents()
            }
        }
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
    
    func checkMark(_ imageView:UIImageView, isRight:Bool) {
        if isRight {
            imageView.image = UIImage(named: "form_checkmark")
        }
        else {
            imageView.image = nil
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == hospitalField && hospitalField.text == "" {
            //selectPicker(hospitalPicker, didSelectRow: 0)
        }
        else if textField == specialField && specialField.text == "" {
            selectPicker(specialPicker, didSelectRow: 0)
        }
        else if textField == jobField && jobField.text == "" {
            selectPicker(jobPicker, didSelectRow: 0)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForm()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if nameField.text == "888" {//Bypass Login Employee
            nameField.text = "test ios"
            emailField.text = "test_ios@mail.com"
            passField.text = "1234"
            hospitalField.text = ""
            jobField.text = ""
            specialField.text = ""
            licenseField.text = "1234"
            submiBtn.enableBtn()
        }
        if textField == emailField {
            mailChecked = false
            emailAlert.isHidden = true
            checkMark(emailCheck, isRight: false)
            
            if isValidEmail(emailField.text!) {
                loadCheckEmail()
            }
        }
        if textField == hospitalField {
            hospitalID = ""
        }
        checkForm()
    }
    
    func checkForm() {
        if nameField.text!.count >= 3 {
            checkMark(nameCheck, isRight: true)
        } else { checkMark(nameCheck, isRight: false) }
        
//        if isValidEmail(emailField.text!) {
//            loadCheckEmail()
//        } else { checkMark(emailCheck, isRight: false) }
        
        if passField.text!.count >= 3 {
            checkMark(passCheck, isRight: true)
        } else { checkMark(passCheck, isRight: false) }
        
        if hospitalID != "" {
            checkMark(hospitalCheck, isRight: true)
        } else { checkMark(hospitalCheck, isRight: false) }
        
        if jobField.text!.count >= 3 {
            checkMark(jobCheck, isRight: true)
        } else { checkMark(jobCheck, isRight: false) }
        
        if specialField.text!.count >= 3 {
            checkMark(specialCheck, isRight: true)
        } else { checkMark(specialCheck, isRight: false) }
        
        if licenseField.text!.count >= 3 {
            checkMark(licenseCheck, isRight: true)
        } else { checkMark(licenseCheck, isRight: false) }
        
        if mailChecked && nameField.text!.count >= 3 && passField.text!.count >= 3 && hospitalID != "" && jobField.text!.count >= 3 && specialField.text!.count >= 3 && licenseField.text!.count >= 3 {
            submiBtn.enableBtn()
        }
        else{
            submiBtn.disableBtn()
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func loadCheckEmail() {
        let parameters:Parameters = ["email":emailField.text!]
        loadRequest(method:.post, apiName:"Register/inspectEmail", authorization:false, showLoadingHUD:false, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS CHECKMAIL\(json)")
                
                if json["error"].boolValue == false {
                    self.mailChecked = true
                    self.emailAlert.isHidden = true
                    self.checkMark(self.emailCheck, isRight: true)
                }
                else {
                    self.emailAlert.isHidden = false
                    self.checkMark(self.emailCheck, isRight: false)
                }
                self.checkForm()
            }
        }
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if emailField.text! == "" {
//            return false
//        } else if textField == emailField {
//            emailField.resignFirstResponder()
//            passField.becomeFirstResponder()
//            return true
//        } else if textField == passField {
//            passField.resignFirstResponder()
//            return true
//        }else {
//            return false
//        }
//    }
    
    @IBAction func secureClick(_ sender: UIButton) {
        if passField.isSecureTextEntry == true {
            passField.isSecureTextEntry = false
            sender.setImage(UIImage(named: "login_password_show.png"), for: .normal)
        }
        else {
            passField.isSecureTextEntry = true
            sender.setImage(UIImage(named: "login_password_hide.png"), for: .normal)
        }
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        confirmAsk()
    }
    
    func confirmAsk() {
        print("Hospital ID = \(hospitalID)\n Special ID = \(specialID)\n Job ID = \(jobID)")
        
        SwiftAlertView.show(title: "Confirm sign up",
                            message: nil,
                            buttonTitles: "Cancel", "Confirm") { alert in
            alert.titleLabel.font = .Alert_Title
            alert.titleLabel.textColor = .textDarkGray
            alert.messageLabel.font = .Alert_Message
            alert.cancelButtonIndex = 0
            alert.button(at: 0)?.titleLabel?.font = .Alert_Button
            alert.button(at: 0)?.setTitleColor(.buttonRed, for: .normal)
            
            alert.button(at: 1)?.titleLabel?.font = .Alert_Button
            alert.button(at: 1)?.setTitleColor(.themeColor, for: .normal)
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
        let parameters:Parameters = ["name":nameField.text!,
                                     "email":emailField.text!,
                                     "password":passField.text!,
                                     "id_hospital":hospitalID,
                                     "id_specialty":specialID,
                                     "job":jobID,
                                     "license":licenseField.text!
        ]
        print(parameters)
        loadRequest(method:.post, apiName:"Register", authorization:false, showLoadingHUD:true, dismissHUD:false, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS REGISTER\(json)")
                
                ProgressHUD.showSuccess(json["message"].stringValue, interaction: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "Login") as! Login
                    self.navigationController!.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func gotoLogin(_ sender: UIButton) {
        let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "Login") as! Login
        
        var viewControllers = self.navigationController?.viewControllers
        viewControllers![viewControllers!.count - 1] = vc
        self.navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}

// MARK: - Picker Datasource
extension SignUp: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == hospitalPicker && hospitalJSON!.count > 0 {
            return hospitalJSON!.count
        }
        else if pickerView == specialPicker && specialJSON!.count > 0 {
            return specialJSON!.count
        }
        else if pickerView == jobPicker && jobJSON!.count > 0 {
            return jobJSON!.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = .Roboto_Regular(ofSize: 22)
            pickerLabel?.textAlignment = .center
        }
        
        if pickerView == hospitalPicker && hospitalJSON!.count > 0 {
            pickerLabel?.text = hospitalJSON![row]["hospital_name"].stringValue
        }
        else if pickerView == specialPicker && specialJSON!.count > 0 {
            pickerLabel?.text = specialJSON![row]["specialty_name"].stringValue
        }
        else if pickerView == jobPicker && jobJSON!.count > 0 {
            pickerLabel?.text = jobJSON![row]["name_jobTitle"].stringValue
        }
        else{
            pickerLabel?.text = ""
        }
        
        pickerLabel?.textColor = .textDarkGray

        return pickerLabel!
    }
    
    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typePicker && leaveJSON!.count > 0{
            return leaveJSON![row]["category_name_en"].stringValue
        }
        else if pickerView == headPicker && headJSON!.count > 0{
            return "\(headJSON![row]["first_name"].stringValue) \(headJSON![row]["last_name"].stringValue)"
        }
        else{
            return ""
        }
    }
 */
}

// MARK: - Picker Delegate
extension SignUp: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //print("Select \(row)")
        selectPicker(pickerView, didSelectRow: row)
    }
    
    func selectPicker(_ pickerView: UIPickerView, didSelectRow row: Int) {
        if pickerView == hospitalPicker {
            hospitalField.text = hospitalJSON![row]["hospital_name"].stringValue
            hospitalID = hospitalJSON![row]["hospital_id"].stringValue
        }
        else if pickerView == specialPicker {
            specialField.text = specialJSON![row]["specialty_name"].stringValue
            specialID = specialJSON![row]["specialty_id"].stringValue
        }
        else if pickerView == jobPicker {
            jobField.text = jobJSON![row]["name_jobTitle"].stringValue
            jobID = jobJSON![row]["id_jobTitle"].stringValue
        }
    }
}
