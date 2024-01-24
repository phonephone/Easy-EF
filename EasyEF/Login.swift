//
//  Login.swift
//  AZ-Echo
//
//  Created by Truk Karawawattana on 14/7/2565 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class Login: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailCheck: UIImageView!
    
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var passCheck: UIImageView!
    @IBOutlet weak var passShowHide: UIButton!
    
    @IBOutlet weak var submiBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setStatusBar(backgroundColor: .themeColor)
        
        passShowHide.imageView?.contentMode = .scaleAspectFit
        
        setupField(emailField)
        setupField(passField)
        
        checkMark(emailCheck, isRight: false)
        checkMark(passCheck, isRight: false)
        
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
            emailField.text = "supachai10319@gmail.com"//"ice@mail.com"
            passField.text = "1234"
            submiBtn.enableBtn()
        }
        checkForm()
    }
    
    func checkForm() {
        if isValidEmail(emailField.text!) {
            checkMark(emailCheck, isRight: true)
        } else { checkMark(emailCheck, isRight: false) }
        
        if passField.text!.count >= 3 {
            checkMark(passCheck, isRight: true)
        } else { checkMark(passCheck, isRight: false) }
        
        if isValidEmail(emailField.text!) && passField.text!.count >= 3 {
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
        print("Login")
        loadSubmit()
    }
    
    func loadSubmit() {
        let parameters:Parameters = ["email":emailField.text!,
                                     "password":passField.text!,
        ]
        loadRequest(method:.post, apiName:"login", authorization:false, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                //print("SUCCESS LOGIN\(json)")
                
                let userID = json["data"]["id_user"].stringValue
                print("LOGIN USER ID = \(userID)")
                UserDefaults.standard.set("\(userID)", forKey: "userID")
                SceneDelegate.GlobalVariables.userID = userID
                self.navigationController!.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func gotoSignUp(_ sender: UIButton) {
        let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "SignUp") as! SignUp
        
        var viewControllers = self.navigationController?.viewControllers
        viewControllers![viewControllers!.count - 1] = vc
        self.navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    
    @IBAction func forgetPasswordClick(_ sender: UIButton) {
        let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "ForgetPassword") as! ForgetPassword
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}
