//
//  EchoDetail.swift
//  AZ-Echo
//
//  Created by Truk Karawawattana on 15/7/2565 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD
import SwiftGifOrigin

class EchoDetail: UIViewController {
    
    var echoType:echoType?
    var videoID: String?
    var patientID: String?
    
    var treatmentJSON:JSON?
    
    @IBOutlet weak var needleImageView: UIImageView!
    @IBOutlet weak var patientLabel: UILabel!
    @IBOutlet weak var guageLabel: UILabel!
    @IBOutlet weak var detailNormal: UILabel!
    @IBOutlet weak var detailModerate: UILabel!
    @IBOutlet weak var detailSevere: UILabel!
    
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var refButton: UIButton!
    @IBOutlet weak var refLabel: UILabel!
    
    let refAttributes: [NSAttributedString.Key: Any] = [
          .font: UIFont.Prompt_SemiBold(ofSize: 12),
          .foregroundColor: UIColor.textGray2,
          .underlineStyle: NSUnderlineStyle.single.rawValue
      ]
    
    @IBOutlet weak var loadingImageView: UIImageView!
    
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var increaseBtn: UIButton!
    
    var guageValue:Int = 50
    var timer: Timer!
    var counter: Int = 0
    
    var normalValue:Float = 0
    var moderateValue:Float = 0
    var severeValue:Float = 0
    
    @IBOutlet weak var treatmentBtn: UIButton!
    @IBOutlet weak var dischargeBtn: UIButton!
    
    @IBOutlet weak var treatmentBtn1: UIButton!
    @IBOutlet weak var treatmentBtn2: UIButton!
    @IBOutlet weak var treatmentBtn3: UIButton!
    @IBOutlet weak var treatmentBtn4: UIButton!
    
    @IBOutlet weak var dischargeBtn1: UIButton!
    @IBOutlet weak var dischargeBtn2: UIButton!
    @IBOutlet weak var dischargeBtn3: UIButton!
    
    var transparentView = UIView()
    @IBOutlet weak var treatmentView: UIView!
    @IBOutlet weak var dischargeView: UIView!
    var treatmentViewHeight:CGFloat = 570
    var dischargeViewHeight:CGFloat = 450
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ECHO DETAIL")
        
        patientLabel.text = ""
        guageLabel.text = "-"//"LVEF : -"
        detailSevere.text = ""
        detailModerate.text = ""
        detailNormal.text = ""
        
        let attributeString = NSMutableAttributedString(
            string: "reference EasyEF AI v1.0",
            attributes: refAttributes
        )
        refButton.setAttributedTitle(attributeString, for: .normal)
        
        let tapDown = UITapGestureRecognizer(target: self, action: #selector(tapDownHandler(_:)))
        tapDown.numberOfTapsRequired = 1
        decreaseBtn.addGestureRecognizer(tapDown)
        
        let longPressDown = UILongPressGestureRecognizer(target: self, action: #selector(longPressDownHandler(_:)))
        decreaseBtn.addGestureRecognizer(longPressDown)
        
        let tapUp = UITapGestureRecognizer(target: self, action: #selector(tapUpHandler(_:)))
        tapUp.numberOfTapsRequired = 1
        increaseBtn.addGestureRecognizer(tapUp)
        
        let longPressUp = UILongPressGestureRecognizer(target: self, action: #selector(longPressUpHandler(_:)))
        increaseBtn.addGestureRecognizer(longPressUp)
        
        treatmentBtn1.imageView?.contentMode = .scaleAspectFit
        treatmentBtn2.imageView?.contentMode = .scaleAspectFit
        treatmentBtn3.imageView?.contentMode = .scaleAspectFit
        treatmentBtn4.imageView?.contentMode = .scaleAspectFit
        
        dischargeBtn1.imageView?.contentMode = .scaleAspectFit
        dischargeBtn2.imageView?.contentMode = .scaleAspectFit
        dischargeBtn3.imageView?.contentMode = .scaleAspectFit
        
        decreaseBtn.isHidden = true
        increaseBtn.isHidden = true
        
        treatmentBtn.isHidden = true
        dischargeBtn.isHidden = true
        
        loadDetail()
        updateDischarge()
    }
    
    func loadDetail() {
        let parameters:Parameters = ["id_vdo":videoID!,//"400",
        ]
        loadRequest(method:.post, apiName:"HFestimation/v2", authorization:false, showLoadingHUD:true, dismissHUD:false, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS EF\(json)")
                
                let status = json["data"]["status"].stringValue
                if status == "OK" {
                    self.normalValue = json["data"]["estimated_hf_output_normal"].floatValue
                    self.moderateValue = json["data"]["estimated_hf_output_moderate"].floatValue
                    self.severeValue = json["data"]["estimated_hf_output_severe"].floatValue
                    
                    self.displayGuage()
                    self.loadTreatment()
                }
                else {
                    self.guageLabel.text = "Error"
                    self.guageLabel.textColor = .textDarkGray
                    self.detailSevere.text = status
                    ProgressHUD.imageError = .remove
                    ProgressHUD.showError(status, interaction: false)
                }
                
                /*
                self.guageLabel.text = "LVEF : \(efStr)"
                //self.detailLabel.text = json["data"]["goodFuntion"][0].stringValue
                
                let efInt = Int(efStr)
                if efInt! > 50 {
                    self.guageIncrease(value: efInt!-50)
                }
                else if efInt! < 50 {
                    self.guageDecrease(value: 50-efInt!)
                }
                */
            }
        }
    }
    
    func displayGuage() {
        let array = [normalValue,moderateValue,severeValue]
        let maxValue = array.max()
        let maxIndex = array.firstIndex(of: maxValue!)
        
        needleImageView.setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.9))
        
        switch maxIndex {
        case 0://Normal
            guageLabel.text = "Preserve"
            guageLabel.textColor = UIColor(red: 73/255, green: 154/255, blue: 139/255, alpha: 1.0)
            self.guageIncrease(value: 85-50)
            
        case 1://Moderate
            guageLabel.text = "Mildly Reduce"
            guageLabel.textColor = UIColor(red: 245/255, green: 190/255, blue: 103/255, alpha: 1.0)
            self.guageIncrease(value: 50-50)
            
        case 2://Severe
            guageLabel.text = "Reduce"
            guageLabel.textColor = UIColor(red: 236/255, green: 98/255, blue: 100/255, alpha: 1.0)
            self.guageIncrease(value: 15-50)
            
        default:
            break
        }
        
        detailSevere.text = "มีโอกาสเป็น Reduce (HFrEF): \(severeValue) %"
        detailModerate.text = "มีโอกาสเป็น Mildly Reduce (HFmrEF) : \(moderateValue) %"
        detailNormal.text = "มีโอกาสเป็น Preserve (HFpEF) : \(normalValue) %"
    }
    
    func loadTreatment() {
        let parameters:Parameters = [:]
        loadRequest(method:.post, apiName:"Treatment", authorization:false, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                //print("SUCCESS TREATMENT\(json)")
                
                self.treatmentJSON = json["data"]
                self.updateTreatmentBtn()
                
                self.treatmentBtn.isHidden = false
                self.dischargeBtn.isHidden = false
            }
        }
    }
    
    func updateTreatmentBtn() {
        
        treatmentBtn1.isHidden = true
        treatmentBtn2.isHidden = true
        treatmentBtn3.isHidden = true
        treatmentBtn4.isHidden = true
        
        if treatmentJSON!.count > 0 { // 1
            treatmentBtn1.isHidden = false
            treatmentBtn1.setTitle(treatmentJSON![0]["title"].stringValue, for: .normal)
            treatmentViewHeight = 210
        }
        if treatmentJSON!.count > 1 { // 2
            treatmentBtn2.isHidden = false
            treatmentBtn2.setTitle(treatmentJSON![1]["title"].stringValue, for: .normal)
            treatmentViewHeight = 330
        }
        if treatmentJSON!.count > 2 { // 3
            treatmentBtn3.isHidden = false
            treatmentBtn3.setTitle(treatmentJSON![2]["title"].stringValue, for: .normal)
            treatmentViewHeight = 450
        }
        if treatmentJSON!.count > 3 { // 4
            treatmentBtn4.isHidden = false
            treatmentBtn4.setTitle(treatmentJSON![3]["title"].stringValue, for: .normal)
            treatmentViewHeight = 570
        }
    }
    
    func updateDischarge() {
        if SceneDelegate.GlobalVariables.dischargeJSON != nil {
            dischargeBtn1.setTitle(SceneDelegate.GlobalVariables.dischargeJSON![0]["dischargeName"].stringValue, for: .normal)
            dischargeBtn2.setTitle(SceneDelegate.GlobalVariables.dischargeJSON![1]["dischargeName"].stringValue, for: .normal)
            dischargeBtn3.setTitle(SceneDelegate.GlobalVariables.dischargeJSON![2]["dischargeName"].stringValue, for: .normal)
        }
    }
    
    @IBAction func tapDownHandler(_ sender: UITapGestureRecognizer) {
        print("Tap")
        self.guageDecrease(value: 15)
    }
    
    @IBAction func longPressDownHandler(_ sender: UILongPressGestureRecognizer) {
            if sender.state == .began {
                counter = 0
                timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: {_ in
                    if self.counter <= 10 {
                        self.guageDecrease(value: 1)
                    }
                    else{
                        self.guageDecrease(value: 5)
                    }
                    self.counter += 1
                })
            } else if sender.state == .ended || sender.state == .cancelled {
                print("FINISHED UP LONG PRESS")
                timer?.invalidate()
                timer = nil
            }
    }
    
    @IBAction func tapUpHandler(_ sender: UITapGestureRecognizer) {
        print("Tap")
        self.guageIncrease(value: 15)
    }
    
    @IBAction func longPressUpHandler(_ sender: UILongPressGestureRecognizer) {
            if sender.state == .began {
                counter = 0
                timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: {_ in
                    if self.counter <= 10 {
                        self.guageIncrease(value: 1)
                    }
                    else{
                        self.guageIncrease(value: 5)
                    }
                    self.counter += 1
                })
            } else if sender.state == .ended || sender.state == .cancelled {
                print("FINISHED UP LONG PRESS")
                timer?.invalidate()
                timer = nil
            }
    }
    
    @IBAction func decreaseClick(_ sender: UIButton) {
        //guageDecrease(value: 10)
    }
    
    @IBAction func increaseClick(_ sender: UIButton) {
        //guageIncrease(value: 10)
    }
    
    func guageDecrease(value:Int) {
        guageValue -= value
        if guageValue < 0 {
            guageValue = 0
        }
        
        let rad: Double = atan2( Double(needleImageView.transform.b), Double(needleImageView.transform.a))
        let degree: CGFloat = CGFloat(rad) * (CGFloat(180) / CGFloat.pi )
        if degree > -90 {
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear, animations: {
                self.needleImageView.transform = self.needleImageView.transform.rotated(by: -CGFloat(Double.pi / 2)*CGFloat((value))/50) //90 degree
            }, completion: nil)
            updateGuageValue(value: value, isIncrease: false)
        }
    }
    
    func guageIncrease(value:Int) {
        guageValue += value
        if guageValue > 100 {
            guageValue = 100
        }
        
        let rad: Double = atan2( Double(needleImageView.transform.b), Double(needleImageView.transform.a))
        let degree: CGFloat = CGFloat(rad) * (CGFloat(180) / CGFloat.pi )
        if degree < 90 {
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear, animations: {
                self.needleImageView.transform = self.needleImageView.transform.rotated(by: CGFloat(Double.pi / 2)*CGFloat((value))/50) //90 degree
            }, completion: nil)
            updateGuageValue(value: value, isIncrease: true)
        }
    }
    
    func updateGuageValue(value:Int, isIncrease:Bool) {
        let rad: Double = atan2( Double(needleImageView.transform.b), Double(needleImageView.transform.a))
        let degree: CGFloat = CGFloat(rad) * (CGFloat(180) / CGFloat.pi )
        print(degree)
        
        var percent = Int((degree/(180/100))+50)
        if percent < 0 {
            percent = 0
        } else if percent > 100 {
            percent = 100
        }
        //self.guageLabel.text = "LVEF : \(percent)"
        
        //print(guageValue)
//        let duration: Double = 1.0 //seconds
//        let oldValue = Int(self.guageLabel.text!)
//        if isIncrease {
//            DispatchQueue.global().async {
//                for i in oldValue!..<(self.guageValue + 1) {
//                    let sleepTime = UInt32(duration/50 * 1000000.0)
//                    usleep(sleepTime)
//                    DispatchQueue.main.async {
//                        self.guageLabel.text = "\(i)"
//                    }
//                }
//            }
//        }
//        else {
//            DispatchQueue.global().async {
//                for i in ((self.guageValue - 0)..<oldValue!).reversed() {
//                    let sleepTime = UInt32(duration/50 * 1000000.0)
//                    usleep(sleepTime)
//                    DispatchQueue.main.async {
//                        self.guageLabel.text = "\(i)"
//                    }
//                }
//            }
//        }
    }
    
    @IBAction func referenceClick(_ sender: UIButton) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "Web") as! Web
        vc.titleString = "EasyEF AI v1.0"
        vc.webUrlString = "xxx"
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func treatmentShow(_ sender: UIButton) {
        let vc = UIStoryboard.guideStoryBoard.instantiateViewController(withIdentifier: "Assessment0_1") as! Assessment0_1
        self.navigationController!.pushViewController(vc, animated: true)
        
        //showBottomSheet(showView: treatmentView, viewHeight: treatmentViewHeight)
    }
    
    @IBAction func dischargeShow(_ sender: UIButton) {
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
            self.treatmentView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.treatmentViewHeight)
            self.dischargeView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.dischargeViewHeight)
        }, completion: nil)
    }
    
    @IBAction func dissmissBottomSheet(_ sender: UIButton) {
        onClickTransParentView()
    }
    
    @IBAction func treatmentClick(_ sender: UIButton) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "Web") as! Web
        vc.titleString = sender.currentTitle
        vc.webUrlString = treatmentJSON![sender.tag]["link"].stringValue
        self.navigationController!.pushViewController(vc, animated: true)
        onClickTransParentView()
    }
    
    @IBAction func dischargeClick(_ sender: UIButton) {
        let vc = UIStoryboard.patientStoryBoard.instantiateViewController(withIdentifier: "DischargeWeb") as! DischargeWeb
        vc.titleString = ""
        vc.webUrlString = "\(SceneDelegate.GlobalVariables.dischargeJSON![sender.tag]["dischargeUrl"].stringValue)/\(patientID!)"
        self.navigationController!.pushViewController(vc, animated: true)
        
        onClickTransParentView()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.removeAnyViewControllers(ofKind: Camera.self)
        self.navigationController?.removeAnyViewControllers(ofKind: UploadVideo.self)
        self.navigationController?.removeAnyViewControllers(ofKind: EchoInput.self)
        self.navigationController!.popViewController(animated: true)
    }
}

extension UIView{
    func setAnchorPoint(anchorPoint: CGPoint) {

        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)

        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)

        var position : CGPoint = self.layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x;

        position.y -= oldPoint.y;
        position.y += newPoint.y;

        self.translatesAutoresizingMaskIntoConstraints = true
        self.layer.position = position;
        self.layer.anchorPoint = anchorPoint;
    }
}
