//
//  Treatment.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 12/1/2567 BE.
//

import UIKit
import SDWebImage

class Treatment: UIViewController {
    
    var resultEF:LVEF?
    
    var imageUrlString:String?
    
    @IBOutlet weak var headTitle: UILabel!
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var doseImage: UIImageView!
    @IBOutlet weak var doseImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var doseImageReduce: UIImageView!
    @IBOutlet weak var doseImageMildly: UIImageView!
    @IBOutlet weak var doseImagePreserve: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Treatment")
        
        myScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        doseImageReduce.isHidden = true
        doseImageMildly.isHidden = true
        doseImagePreserve.isHidden = true
        
        switch resultEF {
        case .Reduced:
            headTitle.text = "ชนิดและขนาดยาที่แนะนำในผู้ป่วย HFrEF"
            //doseImageReduce.isHidden = false
            
        case .Mildly:
            headTitle.text = "ชนิดและขนาดยาที่แนะนำในผู้ป่วย HFmrEF"
            //doseImageMildly.isHidden = false
            
        case .Preserved:
            headTitle.text = "ชนิดและขนาดยาที่แนะนำในผู้ป่วย HFpEF"
            //doseImagePreserve.isHidden = false
        default:
            break
        }
        
        doseImage.sd_setImage(with: URL(string:imageUrlString!),
                               placeholderImage: nil,
                               completed: { (image, error, cacheType, url) in
            guard image != nil else {
                return
            }
            let ratio = image!.size.width / image!.size.height
            let newHeight = self.myScrollView.frame.width / ratio
            print(newHeight)
            self.doseImageHeight.constant = newHeight
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(imageUrlString!)
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func finishClick(_ sender: UIButton) {
        self.navigationController!.popToRootViewController(animated: true)
    }
}

