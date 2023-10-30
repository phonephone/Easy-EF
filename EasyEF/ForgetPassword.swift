//
//  ForgetPassword.swift
//  AZ-Echo
//
//  Created by Truk Karawawattana on 14/7/2565 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class ForgetPassword: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailCheck: UIImageView!
    
    @IBOutlet weak var alertLebel: UILabel!
    
    @IBOutlet weak var submiBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupField(emailField)
        
        checkMark(emailCheck, isRight: false)
        
        continueBtn.isHidden = true
        alertLebel.isHidden = true
        submiBtn.disableBtn()
    }
    
    func setupField(_ textField:UITextField) {
        textField.delegate = self
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
    }
    
    func checkMark(_ imageView:UIImageView, isRight:Bool) {
        if isRight {
            imageView.image = UIImage(named: "form_checkmark")
        }
        else {
            imageView.image = nil
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if emailField.text == "888" {//Bypass Login Employee
            emailField.text = "test_ios@mail.com"//"ice@mail.com"
            submiBtn.enableBtn()
        }
        checkForm()
    }
    
    func checkForm() {
        if isValidEmail(emailField.text!) {
            checkMark(emailCheck, isRight: true)
        } else { checkMark(emailCheck, isRight: false) }
        
        if isValidEmail(emailField.text!) {
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
    
    @IBAction func submitClick(_ sender: UIButton) {
        loadSubmit()
    }
    
    func loadSubmit() {
        
        let parameters:Parameters = ["email":emailField.text!,
        ]
        loadRequest(method:.post, apiName:"ForgotPassword", authorization:false, showLoadingHUD:true, dismissHUD:false, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()

            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS FORGET\(json)")
                
                ProgressHUD.showSuccess(json["message"].stringValue, interaction: false)
                self.submiBtn.isHidden = true
                self.continueBtn.isHidden = false
                self.alertLebel.isHidden = false
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}
