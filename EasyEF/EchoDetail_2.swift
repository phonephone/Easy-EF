//
//  EchoDetail_2.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 5/1/2567 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD
import SwiftGifOrigin

class EchoDetail_2: UIViewController,UITextViewDelegate {
    
    var echoType:echoType?
    var videoID: String?
    var patientID: String?
    
    var treatmentJSON:JSON?
    var refURL: String?
    
    var resultEF:LVEF?
    
    var errorReload:Bool = true
    var noOfReload:Int = 2
    
    @IBOutlet weak var captureView: UIView!
    
    @IBOutlet weak var needleImageView: UIImageView!
    @IBOutlet weak var guageLabel: UILabel!
    @IBOutlet weak var guageDetailLabel: UILabel!
    @IBOutlet weak var guageDetailLabel2: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var confidentLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var refStack: UIStackView!
    @IBOutlet weak var refTitle: UILabel!
    @IBOutlet weak var refButton: UIButton!
    @IBOutlet weak var refLabel: UILabel!
    
    let remarkStr = "กรุณาระบุ: ชื่อคนไข้, HN, โรงพยาบาลที่นี่"
    
    @IBOutlet weak var remarkStack: UIStackView!
    @IBOutlet weak var remarkText: MyTextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    let refAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.Prompt_SemiBold(ofSize: 12),
        .foregroundColor: UIColor.themeColor,
        .underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    
    var guageValue:Int = 50
    var timer: Timer!
    var counter: Int = 0
    
    var normalValue:Float = 0
    var moderateValue:Float = 0
    var severeValue:Float = 0
    
    var normalURLString:String?
    var moderateURLString:String?
    var severeURLString:String?
    var resultURLString:String?
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var shareSubmitBtn: UIButton!
    @IBOutlet weak var treatmentBtn: UIButton!
    @IBOutlet weak var dischargeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ECHO DETAIL 2")
        
        self.navigationController?.setStatusBar(backgroundColor: .themeColor)
        
        //patientLabel.text = ""
        guageLabel.text = ""
        guageDetailLabel.text = ""
        guageDetailLabel2.text = ""
        detailLabel.text = ""
        
        let attributeString = NSMutableAttributedString(
            string: "reference EasyEF AI v1.0",
            attributes: refAttributes
        )
        refButton.setAttributedTitle(attributeString, for: .normal)
        
        treatmentBtn.isHidden = true
        
        remarkText.delegate = self
        remarkText.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        remarkText.contentOffset = CGPoint(x: 0, y: -10)
        remarkText.text = remarkStr
        remarkText.textColor = UIColor.lightGray
        dateLabel.text = appStringFromDate(date: Date(), format: "dd MMM yyyy HH:mm a")
        
        refStack.isHidden = false
        remarkStack.isHidden = true
        
        refTitle.isHidden = true
        refButton.isHidden = true
        refLabel.isHidden = true
        treatmentBtn.isHidden = true
        shareSubmitBtn.isHidden = true
        
        loadDetail()
    }
    
    func loadDetail() {
        let parameters:Parameters = ["id_vdo":videoID!,//"400",
        ]
        loadRequest(method:.post, apiName:"HFestimation/v2", authorization:false, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                print("SUCCESS EF\(json)")
                
                let status = json["data"]["status"].stringValue
                if status == "OK" {
                    self.errorReload = false
                    
                    self.severeValue = json["data"]["estimated_hf_output_severe"].floatValue
                    self.moderateValue = json["data"]["estimated_hf_output_moderate"].floatValue
                    self.normalValue = json["data"]["estimated_hf_output_normal"].floatValue
                    
                    let imageURL = json["data"]["imgUrl"]
                    self.severeURLString = imageURL["reduce"].stringValue
                    self.moderateURLString = imageURL["mildly"].stringValue
                    self.normalURLString = imageURL["preserve"].stringValue
                    
                    self.refURL = json["data"]["refUrl"].stringValue
                    if self.refURL != "" {
                        let attributeString = NSMutableAttributedString(
                            string: self.refURL ?? "",
                            attributes: self.refAttributes
                        )
                        self.refButton.setAttributedTitle(attributeString, for: .normal)
                        
                        self.refTitle.isHidden = false
                        self.refButton.isHidden = false
                        self.refLabel.isHidden = false
                    }
                    
                    self.displayGuage()
                    self.treatmentBtn.isHidden = false
                }
                else {
                    self.guageLabel.text = "Error"
                    self.guageLabel.textColor = .textDarkGray
                    self.detailLabel.text = status
                    
                    self.refTitle.isHidden = true
                    self.refButton.isHidden = true
                    self.refLabel.isHidden = true
                    self.treatmentBtn.isHidden = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                        if self.errorReload && self.noOfReload > 0 {
                            self.noOfReload-=1
                            self.loadDetail()
                        }
                    }
                    
                    ProgressHUD.imageError = .remove
                    ProgressHUD.showError(status, interaction: false)
                }
            }
        }
    }
    
    func displayGuage() {
        let array = [severeValue,moderateValue,normalValue]
        let maxValue = array.max()
        let maxIndex = array.firstIndex(of: maxValue!)
        //let maxIndex = 0 //0,1,2
        
        needleImageView.setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.9))
        
        switch maxIndex {
        case 0://Severe
            resultEF = .Reduced
            
            guageLabel.textColor = UIColor.class2B
            guageLabel.text = "Poor LV"
            guageDetailLabel.text = "HFrEF"
            guageDetailLabel2.text = "(Heart failure with reduced LV Ejection fraction)"
            self.guageIncrease(value: 10-50)
            
            detailLabel.text = "หมายถึง ประสิทธิภาพการทำงานของหัวใจห้องล่างซ้าย น้อยกว่า 40%\nค่านี้ได้มาการการประมวลผลโดย AI จากฐานข้อมูลของ EasyEF"
            confidentLabel.text = "มีความเชื่อมั่นว่าถูกต้อง \(severeValue)%\nมีโอกาสเป็น Good LV \(normalValue)% และ Fair LV \(moderateValue)%"
            
            resultURLString = severeURLString
            
        case 1://Moderate
            resultEF = .Mildly
            
            guageLabel.textColor = UIColor.class2A
            guageLabel.text = "Fair LV"
            guageDetailLabel.text = "HFmrEF"
            guageDetailLabel2.text = "(Heart failure with mildly reduced LV Ejection fraction)"
            self.guageIncrease(value: 50-50)
            
            detailLabel.text = "หมายถึง ประสิทธิภาพการทำงานของหัวใจห้องล่างซ้าย เท่ากับ 40-49%\nค่านี้ได้มาการการประมวลผลโดย AI จากฐานข้อมูลของ EasyEF"
            confidentLabel.text = "มีความเชื่อมั่นว่าถูกต้อง \(moderateValue)%\nมีโอกาสเป็น Good LV \(normalValue)% และ Poor LV \(severeValue)%"
            
            resultURLString = moderateURLString
            
        case 2://Normal
            resultEF = .Preserved
            
            guageLabel.textColor = UIColor.class1A
            guageLabel.text = "Good LV"
            guageDetailLabel.text = "HFpEF"
            guageDetailLabel2.text = "(Heart failure with preserved LV Ejection fraction)"
            self.guageIncrease(value: 90-50)
            
            detailLabel.text = "หมายถึง ประสิทธิภาพการทำงานของหัวใจห้องล่างซ้าย มากกว่า 50%\nค่านี้ได้มาการการประมวลผลโดย AI จากฐานข้อมูลของ EasyEF"
            confidentLabel.text = "มีความเชื่อมั่นว่าถูกต้อง \(normalValue)%\nมีโอกาสเป็น Fair LV \(moderateValue)% และ Poor LV \(severeValue)%"
            
            resultURLString = normalURLString
            
        default:
            break
        }
    }
    
    func guageDecrease(value:Int) {
        guageValue -= value
        if guageValue < 0 {
            guageValue = 0
        }
        
        let rad: Double = atan2( Double(needleImageView.transform.b), Double(needleImageView.transform.a))
        let degree: CGFloat = CGFloat(rad) * (CGFloat(180) / CGFloat.pi )
        if degree > -90 {
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveLinear, animations: {
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
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveLinear, animations: {
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
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == remarkStr {
            textView.text = ""
            textView.textColor = .textDarkGray
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == "" {
            textView.text = remarkStr
            textView.textColor = UIColor.lightGray
        }
        return true
    }
    
    @IBAction func referenceClick(_ sender: UIButton) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "Web") as! Web
        vc.titleString = "Reference"
        vc.webUrlString = refURL
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func treatmentClick(_ sender: UIButton) {
        //        let vc = UIStoryboard.guideStoryBoard.instantiateViewController(withIdentifier: "Assessment0_1") as! Assessment0_1
        //        self.navigationController!.pushViewController(vc, animated: true)
        
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "Treatment") as! Treatment
        vc.resultEF = resultEF
        vc.imageUrlString = resultURLString
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareClick(_ sender: UIButton) {
        if remarkStack.isHidden == true {
            shareBtn.setImage(UIImage(named: "form_x"), for: .normal)
            //shareBtn.imageView?.setImageColor(color: .themeColor)
            
            refStack.isHidden = true
            remarkStack.isHidden = false
            
            treatmentBtn.isHidden = true
            shareSubmitBtn.isHidden = false
        }
        else{
            shareBtn.setImage(UIImage(named: "icon_share"), for: .normal)
            refStack.isHidden = false
            remarkStack.isHidden = true
            
            treatmentBtn.isHidden = false
            shareSubmitBtn.isHidden = true
        }
    }
    
    @IBAction func shareSubmit(_ sender: UIButton) {
        loadingHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.screenShot()
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.removeAnyViewControllers(ofKind: Camera.self)
        self.navigationController?.removeAnyViewControllers(ofKind: UploadVideo.self)
        self.navigationController?.removeAnyViewControllers(ofKind: EchoInput.self)
        self.navigationController!.popViewController(animated: true)
    }
    
    func screenShot() {
        
        
        let image : UIImage = captureView.asImage()
        let shareContent = [image]
        let activityController = UIActivityViewController(activityItems: shareContent,
                                                          applicationActivities: nil)
        activityController.excludedActivityTypes = [.addToReadingList,
                                                    //.airDrop,
                                                    .assignToContact,
                                                    //.copyToPasteboard,
                                                    //.mail,
                                                    .markupAsPDF,
                                                    //.message,
                                                    //.saveToCameraRoll,
                                                    .openInIBooks,
                                                    .postToFacebook,
                                                    .postToFlickr,
                                                    .postToTencentWeibo,
                                                    .postToTwitter,
                                                    .postToVimeo,
                                                    .postToWeibo
        ]
        
        self.present(activityController, animated: true, completion: {
            ProgressHUD.dismiss()
        })
        
        activityController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
        Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                print("share completed")
                return
            } else {
                print("cancel")
            }
            if let shareError = error {
                print("error while sharing: \(shareError.localizedDescription)")
            }
        }
    }
}

extension UIView {
    
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
