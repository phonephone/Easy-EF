//
//  Camera.swift
//  AZ-Echo
//
//  Created by Truk Karawawattana on 26/4/2565 BE.
//

import UIKit
import AVKit
import CameraKit_iOS
import ProgressHUD
import MobileCoreServices

enum echoType {
    case quick
    case validate
    case patient
}

class Camera: UIViewController {
    
    var echoType:echoType?
    var patientID: String?
    
    var editor: VideoEditor!
    var session: CKFVideoSession!
    
    @IBOutlet weak var previewView: CKFPreviewView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var capturBtn: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    var timer: Timer!
    var totalDuration: Double!
    
    var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setStatusBar(backgroundColor: .black)
        
        capturBtn.isHidden = false
        totalDuration = 5
        timeLabel.text = durationFormatter.string(from: TimeInterval(totalDuration))!
        //versionLabel.text = "version \(Bundle.main.appVersionLong)"//(\(Bundle.main.appBuild))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CAMERA")
        editor = VideoEditor()
        session = CKFVideoSession()
        //let session = CKFVideoSession()
        //session.session.sessionPreset = .high
        previewView.session = session
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //session.setWidth(500, height:500, frameRate: 30)
        session.setWidth(Int(previewView.frame.width*3), height:Int(previewView.frame.height*3), frameRate: 30)
        
        previewView.previewLayer?.videoGravity = .resizeAspectFill
        previewView.previewLayer?.position = CGPoint(x: previewView.frame.width/2, y: previewView.frame.height/2)
        previewView.previewLayer?.bounds = previewView.frame
    }
    
    func updateLabels() {
        totalDuration -= 1
        timeLabel.text = durationFormatter.string(from: TimeInterval(totalDuration))!
        
        if totalDuration == 0 {
            self.timer.invalidate()
            stopRecording()
        }
    }
    
    @IBAction func toggleCapture(_ sender: UIButton) {
        if session.isRecording {
            stopRecording()
        }
        else{
            startRecording()
            //VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
        }
    }
    
    func startRecording() {
        print("START")
        capturBtn.isHidden = true
        //totalDuration = 5
        //timeLabel.text = durationFormatter.string(from: TimeInterval(totalDuration))!
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.updateLabels()
        }
        
        // You can also specify a custom url for where to save the video file
        session.record(url: URL(string: ""), { (url) in
            // TODO: Add your code here
            ProgressHUD.show("Loading")
            
            self.editor.makeSquareVideo(fromVideoAt: url, withRatio: self.previewView.frame.size) { exportedURL in
                guard let exportedURL = exportedURL else {
                    return
                }
                
                //                    showVideoPlayer(videoURL: exportedURL)
                
                ProgressHUD.dismiss()
                self.capturBtn.isHidden = false
                
                print("AFTER Res = \(String(describing: self.editor.getVideoResolution(videoURL:exportedURL)))")
                print("AFTER Size = \(String(describing: self.editor.getVideoFileSize(videoURL:exportedURL))) MB")
                
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "UploadVideo") as! UploadVideo
                vc.echoType = self.echoType
                vc.videoURL = exportedURL
                vc.patientID = self.patientID
                self.navigationController!.pushViewController(vc, animated: true)
            }
            
        }) { (error) in
            // TODO: Handle error
        }
    }
    
    func stopRecording() {
        print("STOP")
        
        // You can also specify a custom url for where to save the video file
        session.stopRecording()
    }
    
    func showVideoPlayer(videoURL:URL) {
        let player = AVPlayer(url: videoURL)
        let vcPlayer = AVPlayerViewController()
        vcPlayer.player = player
        self.present(vcPlayer, animated: true, completion: nil)
    }
    
    @IBAction func selectFileClick(_ sender: UIButton) {
        videoPicker()
    }
    
    func videoPicker() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
                self.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}

// MARK: - CKFSessionDelegate
extension Camera: CKFSessionDelegate {
    func didChangeValue(session: CKFSession, value: Any, key: String) {
        if key == "zoom" {
            //self.zoomLabel.text = String(format: "%.1fx", value as! Double)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension Camera: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        else { return }
        
        dismiss(animated: true) {
            print("Video Res = \(String(describing: self.editor.getVideoResolution(videoURL:url)))")
            print("Video Size = \(String(describing: self.editor.getVideoFileSize(videoURL:url))) MB")
            
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "UploadVideo") as! UploadVideo
            vc.echoType = self.echoType
            vc.videoURL = url
            vc.patientID = self.patientID
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension Camera: UINavigationControllerDelegate {
}
