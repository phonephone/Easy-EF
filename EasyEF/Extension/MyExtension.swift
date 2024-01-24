//
//  RoundRect.swift
//  Saw Grow
//
//  Created by Truk Karawawattana on 3/11/2564 BE.
//

import Foundation
import UIKit
import Alamofire
import ProgressHUD
import SideMenuSwift
import SwiftyJSON

extension HTTPHeaders {
    static let websiteURL = "https://echo.tmadigital.com/"
    static let baseURL = "\(websiteURL)ApiApp/"
    
    static let headerWithAuthorize = ["Authorization": "Bearer ",
                                      "Accept": "application/json"] as HTTPHeaders
    
    static let header = ["Accept": "application/json"] as HTTPHeaders
}

// MARK: - Color & Font & Value
extension UIColor {
    static let themeColor = UIColor(named: "Main_Theme_1")!
    static let themeColor2 = UIColor(named: "Main_Theme_2")!
    static let textDarkGray = UIColor(named: "Text_Dark_Gray")!
    static let textGray1 = UIColor(named: "Text_Gray_1")!
    static let textGray2 = UIColor(named: "Text_Gray_2")!
    static let buttonRed = UIColor(named: "Btn_Red")!
    static let buttonGreen = UIColor(named: "Btn_Green")!
    static let buttonDisable = UIColor(named: "Btn_Disable")!
    static let class1A = UIColor(named: "Class1A")!
    static let class2A = UIColor(named: "Class2A")!
    static let class2B = UIColor(named: "Class2B")!
}

extension UIFont {
    class func Prompt_Regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Prompt-Regular", size: size)!
    }
    class func Prompt_Medium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Prompt-Medium", size: size)!
    }
    class func Prompt_SemiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Prompt-SemiBold", size: size)!
    }
    class func Prompt_Bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Prompt-Bold", size: size)!
    }
    
    class func Roboto_Regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    class func Roboto_Medium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size)!
    }
    class func Roboto_Bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: size)!
    }
    
    static let Alert_Title = UIFont(name: "Roboto-Medium", size: 18)!
    static let Alert_Message = UIFont(name: "Roboto-Regular", size: 16)!
    static let Alert_Button = UIFont(name: "Roboto-Regular", size: 18)!
}


// MARK: - UIStoryboard
extension UIStoryboard  {
    static let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    static let loginStoryBoard = UIStoryboard(name: "Login", bundle: nil)
    static let patientStoryBoard = UIStoryboard(name: "Patient_Discharge", bundle: nil)
    static let guideStoryBoard = UIStoryboard(name: "Guide", bundle: nil)
}


// MARK: - Bundle
extension Bundle {
    public var appName: String { getInfo("CFBundleName")  }
    public var displayName: String {getInfo("CFBundleDisplayName")}
    public var language: String {getInfo("CFBundleDevelopmentRegion")}
    public var identifier: String {getInfo("CFBundleIdentifier")}
    public var copyright: String {getInfo("NSHumanReadableCopyright")}
    public var appBuild: String { getInfo("CFBundleVersion") }
    public var appVersionLong: String { getInfo("CFBundleShortVersionString") }
    public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}

// MARK: - UINavigationController
extension UINavigationController {
    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }
    
    func removeAnyViewControllers(ofKind kind: AnyClass)
    {
        self.viewControllers = self.viewControllers.filter { !$0.isKind(of: kind)}
    }
    
    func containsViewController(ofKind kind: AnyClass) -> Bool
    {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
}

// MARK: - UIViewController
extension UIViewController {
    
    func embed(_ viewController:UIViewController, inView view:UIView){
        viewController.willMove(toParent: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    func unEmbed(_ viewController:UIViewController){
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.didMove(toParent: nil)
    }
    
    func switchToLogin() {
        let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "PreLogin") as! PreLogin
        self.navigationController!.setViewControllers([vc], animated: true)
    }
    
    func switchToHome() {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "Home") as! Home
        
        self.navigationController!.setViewControllers([vc], animated: true)
    }
    
    func logOut() {
        self.switchToLogin()
    }
    
    func loadingHUD() {
        //ProgressHUD.show("Loading", interaction: false)
        ProgressHUD.imageError = UIImage.gif(name: "loading")!
        ProgressHUD.showError("Loading", interaction: false, delay: 60)
    }
    
    func submitSuccess(completionBlock: () -> Void) {
        ProgressHUD.showSuccess("Success", interaction: false)
        completionBlock()
    }
    
    func showErrorNoData() {
        ProgressHUD.imageError = .remove
        ProgressHUD.showError("No Data", interaction: false)
    }
    
    func showComingSoon() {
        //ProgressHUD.imageError = UIImage(named:"coming_soon")!
        ProgressHUD.imageError = .remove
        ProgressHUD.showError("Coming Soon", interaction: false)
    }
    
    func loadRequest(method:HTTPMethod, apiName:String, authorization:Bool, showLoadingHUD:Bool, dismissHUD:Bool, parameters:Parameters, completion: @escaping (AFResult<AnyObject>) -> Void) {
        
        if showLoadingHUD == true
        {
            loadingHUD()
        }
        
        let baseURL = HTTPHeaders.baseURL
        let fullURL = baseURL+apiName
        
        var headers: HTTPHeaders
        if authorization == true {
            //let accessToken = UserDefaults.standard.string(forKey:"access_token")
            headers = HTTPHeaders.headerWithAuthorize
        }
        else{
            headers = HTTPHeaders.header
        }
        //print("HEADER = \(headers)")
        //print("PARAM = \(parameters)")
        
        AF.request(fullURL,
                   method: method,
                   parameters: parameters,
                   //encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            
            //debugPrint(response)
            
            switch response.result {
            case .success(let data as AnyObject):

                let json = JSON(data)
                if json["status"] == 200 {
                    if showLoadingHUD == true && dismissHUD == true
                    {
                        ProgressHUD.dismiss()
                    }
                    completion(.success(data))
                }
                else{
                    ProgressHUD.showError(json["message"].stringValue)
                    //ProgressHUD.showFailed(json["data"][0]["error"].stringValue)
                }
                
            case .failure(let error):
                completion(.failure(error))
                
            default:
                fatalError("received non-dictionary JSON response")
            }
        }
    }
    
    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func blurViewSetup() -> UIVisualEffectView{
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blurView = UIVisualEffectView (effect: blurEffect)
        blurView.bounds = self.view.bounds
        blurView.center = self.view.center
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tap)
        
        return blurView
    }
    
    func popIn(popupView : UIView) {
        let backgroundView = self.tabBarController!.view
        
        //        let blurView = blurViewSetup()
        //        blurView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        //        blurView.alpha = 0
        //        backgroundView!.addSubview(blurView)
        
        //popupView.center = backgroundView!.center
        popupView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        popupView.alpha = 0
        
        backgroundView!.addSubview(popupView)
        
        UIView.animate(withDuration: 0.3, animations:{
            //blurView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            //blurView.alpha = 1
            
            popupView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            popupView.alpha = 1
        })
    }
    
    func popOut(popupView : UIView) {
        UIView.animate(withDuration: 0.3, animations:{
            popupView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            popupView.alpha = 1
        }, completion: {_ in
            popupView.removeFromSuperview()
        })
    }
    
    @objc func blurViewTapped(_ sender: UITapGestureRecognizer) {
        //sender.view?.removeFromSuperview()
        print("Tap Blur")
    }
    
    func colorFromRGB(rgbString : String) -> UIColor{
        let rgbArray = rgbString.components(separatedBy: ", ")
        
        let red = Float(rgbArray[0])!
        let green = Float(rgbArray[1])!
        let blue = Float(rgbArray[2])!
        
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1.0)
        return color
    }
    
    func dateFromServerString(dateStr:String) -> Date? {
        if let dtDate = DateFormatter.serverFormatter.date(from: dateStr){
            return dtDate as Date?
        }
        return nil
    }
    
    func dateToServerString(date:Date) -> String{
        let strdt = DateFormatter.serverFormatter.string(from: date)
        if let dtDate = DateFormatter.serverFormatter.date(from: strdt){
            return DateFormatter.serverFormatter.string(from: dtDate)
        }
        return "-"
    }
    
    func appDateFromString(dateStr:String, format:String) -> Date?{
        let dateFormatter:DateFormatter = DateFormatter.customFormatter
        dateFormatter.dateFormat = format
        if let dtDate = dateFormatter.date(from: dateStr){
            return dtDate as Date?
        }
        return nil
    }
    
    func appStringFromDate(date:Date, format:String) -> String{
        let dateFormatter:DateFormatter = DateFormatter.customFormatter
        dateFormatter.dateFormat = format
        let strdt = dateFormatter.string(from: date)
        if let dtDate = dateFormatter.date(from: strdt){
            return dateFormatter.string(from: dtDate)
        }
        return "-"
    }
}//end UIViewController

// MARK: - UIView
extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        self.layer.mask = mask
    }
}

// MARK: - UIImageView
extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}


// MARK: - UIImage
extension UIImage {
    static let circleBoxOFF = UIImage(named: "check_circle_off")!
    static let circleBoxON = UIImage(named: "check_circle_on")!
    static let squareBoxOFF = UIImage(named: "check_square_off")!
    static let squareBoxON = UIImage(named: "check_square_on")!
    
    func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func convertImageToBase64String () -> String {
        return self.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
    }
}


// MARK: - UIButton
extension UIButton {
    func disableBtn() {
        isEnabled = false
        backgroundColor = UIColor.buttonDisable
        setTitleColor(.gray, for: .normal)
    }
    
    func enableBtn() {
        isEnabled = true
        backgroundColor = UIColor.themeColor
        setTitleColor(.white, for: .normal)
    }
}


// MARK: - UITextField
extension UITextField {
    func setUI () {
        self.borderStyle = .none
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}


// MARK: - String
extension String {
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(_ find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}


// MARK: - Date
extension Date {
    //    init(_ dateString:String) {
    //        let dateStringFormatter = DateFormatter()
    //        dateStringFormatter.locale = Locale(identifier: "en_US")
    //        dateStringFormatter.dateFormat = "yyyy-MM-dd"
    //        let date = dateStringFormatter.date(from: dateString)!
    //        self.init(timeInterval:0, since:date)
    //    }
}


// MARK: - DateFormatter
extension DateFormatter {
    //    static let iso8601Full: DateFormatter = {
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //        formatter.calendar = Calendar(identifier: .iso8601)
    //        formatter.timeZone = TimeZone(secondsFromGMT: 0)
    //        formatter.locale = Locale(identifier: "en_US_POSIX")
    //        return formatter
    //    }()
    
    static let serverFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US")//Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
    
    static let serverWihtTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US")//Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
    
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
}


// MARK: - UIAlertController & UIAlertAction
extension UIAlertController {
    func setColorAndFont(){
        
        let attributesTitle = [NSAttributedString.Key.foregroundColor: UIColor.textDarkGray, NSAttributedString.Key.font: UIFont.Prompt_Medium(ofSize: 20)]
        let attributesMessage = [NSAttributedString.Key.foregroundColor: UIColor.textDarkGray, NSAttributedString.Key.font: UIFont.Prompt_Regular(ofSize: 16)]
        let attributedTitleText = NSAttributedString(string: self.title ?? "", attributes: attributesTitle as [NSAttributedString.Key : Any])
        let attributedMessageText = NSAttributedString(string: self.message ?? "", attributes: attributesMessage as [NSAttributedString.Key : Any])
        
        self.setValue(attributedTitleText, forKey: "attributedTitle")
        self.setValue(attributedMessageText, forKey: "attributedMessage")
    }
}

extension UIAlertAction {
    var titleTextColor: UIColor? {
        get { return self.value(forKey: "titleTextColor") as? UIColor }
        set { self.setValue(newValue, forKey: "titleTextColor") }
    }
}

// MARK: - UIScrollView
extension UIScrollView {
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }

    // Bonus: Scroll to top
    func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: true)
    }

    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
