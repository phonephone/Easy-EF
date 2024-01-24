//
//  UploadVideo.swift
//  AZ-Echo
//
//  Created by Truk Karawawattana on 28/4/2565 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD
import AVKit
import SwiftAlertView

class UploadVideo: UIViewController,AVPlayerViewControllerDelegate {
    
    var echoType:echoType?
    var videoURL: URL!
    var patientID: String?
    
    var player: AVPlayer!
    var vcPlayer: AVPlayerViewController!
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var noteField: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setStatusBar(backgroundColor: .themeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("UPLOAD VIDEO")
        
        //coverImage.image = generateThumbImage(url: videoURL)
        
        embedVideoPlayer()
        
        //submitBtn.disableBtn()
        //self.saveVideo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func generateThumbImage(url: URL) -> UIImage? {
        let asset : AVAsset = AVAsset.init(url: url)
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time : CMTime = CMTimeMake(value: 1, timescale: 30)
        
        if let img = try? assetImgGenerate.copyCGImage(at:time, actualTime: nil) {
            return UIImage(cgImage: img)
        } else {
            return nil
        }
    }
    
    func embedVideoPlayer() {
//        let player = AVPlayer(url: videoURL)
//        let vcPlayer = AVPlayerViewController()
        player = AVPlayer(url: videoURL)
        vcPlayer = AVPlayerViewController()
        vcPlayer.player = player
        vcPlayer.view.frame = CGRect(x: 0, y: 0, width: coverView.frame.width, height: coverView.frame.height)
        coverView.addSubview(vcPlayer.view)
        //player.play()
        //self.present(vcPlayer, animated: true, completion: nil)
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        SwiftAlertView.show(title: "Confirm upload video",
                            message: "Notes: \(noteField.text!)",
                            buttonTitles: "Cancel", "Upload") { alert in
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
//                                    self.saveVideo()
                                    self.uploadVideo()
                                default:
                                    break
                                }
                            }
    }
    
    func saveVideo() {
        UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoURL.path)
        UISaveVideoAtPathToSavedPhotosAlbum(
            videoURL.path,
          self,
          #selector(video(_:didFinishSavingWithError:contextInfo:)),
          nil)
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject
    ) {
      let title = (error == nil) ? "Success" : "Error"
      let message = (error == nil) ? "Video was saved" : "Video failed to save"

      let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert)
      alert.addAction(UIAlertAction(
        title: "OK",
        style: UIAlertAction.Style.cancel,
        handler: nil))
      present(alert, animated: true, completion: nil)
    }
    
    func uploadVideo() {
        ProgressHUD.showProgress("Compressing Video", 0.0, interaction: false)
        
        let timestamp = NSDate().timeIntervalSince1970 // just for some random name.

        AF.upload(multipartFormData: { (multiPart) in
            multiPart.append(self.videoURL, withName: "fileUpload" , fileName: "\(timestamp).mp4", mimeType: "video/mp4")
            
            let userID = SceneDelegate.GlobalVariables.userID//UIDevice.current.identifierForVendor!.uuidString
            multiPart.append(userID.data(using: .utf8)!, withName: "id_user")
            
            if self.noteField.text != "" {
                multiPart.append(self.noteField.text!.data(using: .utf8)!, withName: "note")
            }
            
        }, to: "\(HTTPHeaders.baseURL)Vdo/vdoUpload")
            .uploadProgress(closure: { (progress) in
                print("Upload Progress: \(progress.fractionCompleted)")
                ProgressHUD.showProgress("Compressing Video", progress.fractionCompleted, interaction: false)
                if progress.fractionCompleted == 1.0 {
                    ProgressHUD.show("Uploading", interaction: false)
                }
            })
            
            .responseJSON { (response) in
            //debugPrint(response)
            
            switch response.result {
            case .success(let data as AnyObject):
                
                let json = JSON(data)
                print("SUCCESS UPLOAD\(json)")
                if json["status"] == 200 {
                    ProgressHUD.showSucceed(json["message"].stringValue)
                    //ProgressHUD.showSuccess(json["message"]["success"].stringValue)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // Change `2.0` to the desired number of seconds.
                        
                        if self.echoType == .quick {
                            let vc = self.storyboard!.instantiateViewController(withIdentifier: "EchoDetail_2") as! EchoDetail_2
                            vc.echoType = self.echoType
                            vc.videoID = json["data"]["id_vdo"].stringValue
                            vc.patientID = self.patientID
                            self.navigationController!.pushViewController(vc, animated: true)
                        } else {
                            let vc = self.storyboard!.instantiateViewController(withIdentifier: "EchoInput") as! EchoInput
                            vc.echoType = self.echoType
                            vc.videoID = json["data"]["id_vdo"].stringValue
                            vc.patientID = self.patientID
                            self.navigationController!.pushViewController(vc, animated: true)
                        }
                        //id_vdo = 289
                    }
                }
                else{
                    ProgressHUD.showError(json["message"].stringValue)
                    //ProgressHUD.showFailed(json["data"][0]["error"].stringValue)
                }
                
            case .failure(let error):
                ProgressHUD.showFailed(error.localizedDescription)
                
            default:
                fatalError("received non-dictionary JSON response")
            }
        }
        
//        to: uploadURL, method: .post, headers: ["Content-Type": "application/json")
//
//                    .uploadProgress(closure: { (progress) in
//                        print("Upload Progress: \(progress.fractionCompleted)")
//                    })
//
//                    .responseJSON{ (response) in
//                        debugPrint("SUCCESS RESPONSE: \(response)")
//                     }
//                }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}
