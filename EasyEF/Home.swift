//
//  Home.swift
//  AZ-Echo
//
//  Created by Truk Karawawattana on 14/7/2565 BE.
//

import UIKit
import AVKit
import Alamofire
import SwiftyJSON
import ProgressHUD
import SwiftAlertView

class Home: UIViewController {
    
    var profileJSON:JSON?
    var dischargeJSON:JSON?
    var guideLineJSON:JSON?
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var loginStack: UIStackView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var easyBtn: UIButton!
    
    @IBOutlet weak var quickBtn: UIButton!
    @IBOutlet weak var validateBtn: UIButton!
    @IBOutlet weak var patientBtn: UIButton!
    
    @IBOutlet weak var dischargeBtn1: UIButton!
    @IBOutlet weak var dischargeBtn2: UIButton!
    @IBOutlet weak var dischargeBtn3: UIButton!
    
    @IBOutlet weak var guideLineBtn1: UIButton!
    @IBOutlet weak var guideLineBtn2: UIButton!
    @IBOutlet weak var guideLineBtn3: UIButton!
    @IBOutlet weak var guideLineBtn4: UIButton!
    
    @IBOutlet weak var assessmentBtn: UIButton!
    @IBOutlet weak var doseBtn: UIButton!
    
    var transparentView = UIView()
    @IBOutlet weak var easyView: UIView!
    @IBOutlet weak var dischargeView: UIView!
    @IBOutlet weak var guideLineView: UIView!
    var easyViewHeight:CGFloat = 450//3 menu
    var dischargeViewHeight:CGFloat = 450//3 menu
    var guideLineViewHeight:CGFloat = 330//2 menu ,570 = 4 menu
    
    let demoCollection = [
        CollectionModel(image: UIImage(named: "home_1")!, title: ""),
        CollectionModel(image: UIImage(named: "home_2")!, title: ""),
        CollectionModel(image: UIImage(named: "home_3")!, title: ""),
    ]
    
    var tapCount = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateLoginStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HOME")
        
        //Mark:- application move to bckground
        NotificationCenter.default.addObserver(self, selector:#selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        //Mark:- application move to foreground
        NotificationCenter.default.addObserver(self, selector:#selector(appMovedToForeground),name: UIApplication.willEnterForegroundNotification, object: nil)
        
//        myCollectionView.delegate = self
//        myCollectionView.dataSource = self
//        myCollectionView.backgroundColor = .clear
        
        versionLabel.text = "Version \(Bundle.main.appVersionLong)(\(Bundle.main.appBuild))"
        
        setupButton(button: easyBtn)
        setupButton(button: quickBtn)
        setupButton(button: validateBtn)
        setupButton(button: patientBtn)
        
        dischargeBtn1.imageView?.contentMode = .scaleAspectFit
        dischargeBtn2.imageView?.contentMode = .scaleAspectFit
        dischargeBtn3.imageView?.contentMode = .scaleAspectFit
        
        guideLineBtn1.imageView?.contentMode = .scaleAspectFit
        guideLineBtn2.imageView?.contentMode = .scaleAspectFit
        guideLineBtn3.imageView?.contentMode = .scaleAspectFit
        guideLineBtn4.imageView?.contentMode = .scaleAspectFit
        
        assessmentBtn.imageView?.contentMode = .scaleAspectFit
        doseBtn.imageView?.contentMode = .scaleAspectFit
        
        loadDischarge()
        //loadGuide()
    }
    
    func setupButton(button:UIButton) {
        button.imageView?.contentMode = .scaleAspectFit
//        button.contentHorizontalAlignment = .fill
//        button.contentVerticalAlignment = .fill
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -0, bottom: 0, right: 0);
//        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: -0);
    }
    
    func updateLoginStatus() {
        if SceneDelegate.GlobalVariables.userID == "" {
            loginStack.isHidden = false
            logoutBtn.isHidden = true
            patientBtn.isHidden = true
            easyViewHeight = 330
        } else {
            loadProfile()
            loginStack.isHidden = true
            logoutBtn.isHidden = false
            patientBtn.isHidden = false
            easyViewHeight = 450
        }
    }
    
    func loadProfile() {
        let parameters:Parameters = ["id_user":SceneDelegate.GlobalVariables.userID]
        loadRequest(method:.get, apiName:"Profile", authorization:false, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS PROFILE\(json)")
                
                self.profileJSON = json["data"]
                self.logoutBtn.setTitle("\(self.profileJSON!["email_user"].stringValue) | logout", for: .normal)
            }
        }
    }
    
    @IBAction func loginClick(_ sender: UIButton) {
        let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "Login") as! Login
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func signupClick(_ sender: UIButton) {
        let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "SignUp") as! SignUp
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func logoutClick(_ sender: UIButton) {
        confirmAsk()
    }
    
    func confirmAsk() {
        SwiftAlertView.show(title: "Confirm logoff",
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
                                    UserDefaults.standard.removeObject(forKey:"userID")
                                    SceneDelegate.GlobalVariables.userID = ""
                                    self.updateLoginStatus()
                                default:
                                    break
                                }
                            }
    }
    
    func loadDischarge() {
        let parameters:Parameters = [:]
        loadRequest(method:.get, apiName:"DischargeV3/dischargeWeb", authorization:false, showLoadingHUD:false, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS DISCHARGE\(json)")
                
                SceneDelegate.GlobalVariables.dischargeJSON = json["data"]
                //self.dischargeJSON = json["data"]
                self.updateDischarge()
            }
        }
    }
    
    func updateDischarge() {
//        dischargeBtn1.setTitle(dischargeJSON![0]["dischargeName"].stringValue, for: .normal)
//        dischargeBtn2.setTitle(dischargeJSON![1]["dischargeName"].stringValue, for: .normal)
//        dischargeBtn3.setTitle(dischargeJSON![2]["dischargeName"].stringValue, for: .normal)
        
        dischargeBtn1.setTitle(SceneDelegate.GlobalVariables.dischargeJSON![0]["dischargeName"].stringValue, for: .normal)
        dischargeBtn2.setTitle(SceneDelegate.GlobalVariables.dischargeJSON![1]["dischargeName"].stringValue, for: .normal)
        dischargeBtn3.setTitle(SceneDelegate.GlobalVariables.dischargeJSON![2]["dischargeName"].stringValue, for: .normal)
    }
    
    func loadGuide() {
        let parameters:Parameters = ["":""]
        loadRequest(method:.get, apiName:"Guideline", authorization:false, showLoadingHUD:false, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS GUIDE\(json)")
                
                self.guideLineJSON = json["data"]
                self.updateGuideLine()
            }
        }
    }
    
    func updateGuideLine() {
        guideLineBtn1.setTitle(guideLineJSON![0]["title"].stringValue, for: .normal)
        guideLineBtn2.setTitle(guideLineJSON![1]["title"].stringValue, for: .normal)
        guideLineBtn3.setTitle(guideLineJSON![2]["title"].stringValue, for: .normal)
        guideLineBtn4.setTitle(guideLineJSON![3]["title"].stringValue, for: .normal)
    }
    
    @IBAction func guideLineShow(_ sender: UIButton) {
        showBottomSheet(showView: guideLineView, viewHeight: guideLineViewHeight)
    }
    
    @IBAction func guideLineClick(_ sender: UIButton) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "Web") as! Web
        vc.titleString = guideLineJSON![sender.tag]["title"].stringValue
        vc.webUrlString = guideLineJSON![sender.tag]["file"].stringValue
        self.navigationController!.pushViewController(vc, animated: true)
        onClickTransParentView()
    }
    
    @IBAction func assessmentClick(_ sender: UIButton) {
        let vc = UIStoryboard.guideStoryBoard.instantiateViewController(withIdentifier: "Assessment0_1") as! Assessment0_1
        self.navigationController!.pushViewController(vc, animated: true)
        onClickTransParentView()
    }
    
    @IBAction func doseClick(_ sender: UIButton) {
        let vc = UIStoryboard.guideStoryBoard.instantiateViewController(withIdentifier: "Dose") as! Dose
        self.navigationController!.pushViewController(vc, animated: true)
        onClickTransParentView()
    }
    
    @IBAction func easyClick(_ sender: UIButton) {
        checkCameraAccess()
    }
    
    @IBAction func disChargeShow(_ sender: UIButton) {
        showBottomSheet(showView: dischargeView, viewHeight: dischargeViewHeight)
    }
    
    func showBottomSheet(showView:UIView, viewHeight:CGFloat) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        window?.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        showView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: viewHeight)
        showView.roundCorners(corners: [.topLeft,.topRight], radius: 30)
        window?.addSubview(showView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransParentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { [self] in
            self.transparentView.alpha = 0.7
            showView.frame = CGRect(x: 0, y: screenSize.height - viewHeight, width: screenSize.width, height: viewHeight)
        }, completion: nil)
    }
    
    @objc func onClickTransParentView() { //Hide Bottom Sheet
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
            self.easyView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.easyViewHeight)
            self.dischargeView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.dischargeViewHeight)
            self.guideLineView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.guideLineViewHeight)
        }, completion: nil)
    }
    
    @IBAction func dissmissBottomSheet(_ sender: UIButton) {
        onClickTransParentView()
    }
    
    @IBAction func quickBtnClick(_ sender: UIButton) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "Camera") as! Camera
        vc.echoType = .quick
        self.navigationController!.pushViewController(vc, animated: true)
        //ProgressHUD.showError("กำลังอยู่ระหว่างการพัฒนา", interaction: false)
        onClickTransParentView()
    }
    
    @IBAction func validateBtnClick(_ sender: UIButton) {
        if SceneDelegate.GlobalVariables.userID == "" {
            let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "Login") as! Login
            self.navigationController!.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "Camera") as! Camera
            vc.echoType = .validate
            vc.patientID = ""
            self.navigationController!.pushViewController(vc, animated: true)
        }
        onClickTransParentView()
    }
    
    @IBAction func patientBtnClick(_ sender: UIButton) {
        let vc = UIStoryboard.patientStoryBoard.instantiateViewController(withIdentifier: "PatientList") as! PatientList
        self.navigationController!.pushViewController(vc, animated: true)
        onClickTransParentView()
    }
    
    @IBAction func dischargeClick(_ sender: UIButton) {
        let vc = UIStoryboard.patientStoryBoard.instantiateViewController(withIdentifier: "DischargeWeb") as! DischargeWeb
        vc.titleString = ""
        vc.webUrlString = "\(SceneDelegate.GlobalVariables.dischargeJSON![sender.tag]["dischargeUrl"].stringValue)/\(SceneDelegate.GlobalVariables.userID)/0" 
        self.navigationController!.pushViewController(vc, animated: true)
        
        onClickTransParentView()
    }
    
    //Mark:- background method implementation
    @objc func appMovedToBackground() {
        print("App moved to background!")
    }
    
    //Mark:- foreground method implementation
    @objc func appMovedToForeground() {
        print("App moved to foreground!")
//        checkCameraAccess()
    }
}

// MARK: - Camera Permission

extension Home {
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
            showBottomSheet(showView: easyView, viewHeight: easyViewHeight)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    self.showBottomSheet(showView: self.easyView, viewHeight: self.easyViewHeight)
                } else {
                    print("Permission denied")
                    self.presentCameraSettings()
                }
            }
        default:
            break
        }
    }

    func presentCameraSettings() {
//        let alertController = UIAlertController(title: "ไม่ได้รับอนุญาตให้เข้าถึงกล้อง",
//                                      message: "\nกรุณาอนุญาตให้เข้าถึงกล้องเพื่อบันทึกวิดีโอ",
//                                      preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
//            self.presentCameraSettings()
//        })
//
//        alertController.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
//            if let url = URL(string: UIApplication.openSettingsURLString) {
//                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
//                    // Handle
//                })
//            }
//        })
//
//        DispatchQueue.main.async {
//            self.present(alertController, animated: true)
//        }
        
        SwiftAlertView.show(title: "ไม่ได้รับอนุญาตให้เข้าถึงกล้อง",
                            message: "กรุณาอนุญาตให้เข้าถึงกล้องเพื่อบันทึกวิดีโอ",
                            buttonTitles: "ยกเลิก", "ยืนยัน") { alert in
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
                                case 0:
                                    self.presentCameraSettings()
                                case 1:
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                                            // Handle
                                        })
                                    }
                                default:
                                    break
                                }
                            }
    }
}
