//
//  PatientDetail.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 26/8/2565 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

enum detailType {
    case echo
    case discharge
}

class PatientDetail: UIViewController  {
    
    var detailType:detailType?
    
    var patientID: String?
    var patientJSON:JSON?
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var dischargeBtn: UIButton!
    @IBOutlet weak var dischargeBtn1: UIButton!
    @IBOutlet weak var dischargeBtn2: UIButton!
    @IBOutlet weak var dischargeBtn3: UIButton!
    
    var transparentView = UIView()
    @IBOutlet weak var dischargeView: UIView!
    var dischargeViewHeight:CGFloat = 450
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PATIENT LIST")
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.backgroundColor = .clear
        //myCollectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        
        easyBtn.imageView?.contentMode = .scaleAspectFit
        dischargeBtn1.imageView?.contentMode = .scaleAspectFit
        dischargeBtn2.imageView?.contentMode = .scaleAspectFit
        dischargeBtn3.imageView?.contentMode = .scaleAspectFit
        updateDischarge()
        
        if detailType == .echo {
            headerTitle.text = "Echo"
            easyBtn.isHidden = false
            dischargeBtn.isHidden = true
        }
        else if detailType == .discharge {
            headerTitle.text = "Discharge"
            easyBtn.isHidden = true
            dischargeBtn.isHidden = false
        }
        
        loadList()
    }
    
    func loadList() {
        let parameters:Parameters = ["id_patients":patientID!]
        var url:String!
        if detailType == .echo {
            url = "Patients/Vdo"
        }
        else if detailType == .discharge {
            url = "Patients/Discharge"
        }
        loadRequest(method:.post, apiName:url, authorization:false, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
                
            case .success(let responseObject):
                let json = JSON(responseObject)
                //print("SUCCESS PATIENT\(json)")
                
                self.patientJSON = json["data"]
                self.myCollectionView.reloadData()
            }
        }
    }
    
    func updateDischarge() {
        dischargeBtn1.setTitle(SceneDelegate.GlobalVariables.dischargeJSON![0]["dischargeName"].stringValue, for: .normal)
        dischargeBtn2.setTitle(SceneDelegate.GlobalVariables.dischargeJSON![1]["dischargeName"].stringValue, for: .normal)
        dischargeBtn3.setTitle(SceneDelegate.GlobalVariables.dischargeJSON![2]["dischargeName"].stringValue, for: .normal)
    }
    
    @IBAction func easyBtnClick(_ sender: UIButton) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "Camera") as! Camera
        vc.echoType = .validate
        vc.patientID = patientID
        self.navigationController!.pushViewController(vc, animated: true)
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
            self.dischargeView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.dischargeViewHeight)
        }, completion: nil)
    }
    
    @IBAction func dissmissBottomSheet(_ sender: UIButton) {
        onClickTransParentView()
    }
    
    @IBAction func dischargeClick(_ sender: UIButton) {
        let vc = UIStoryboard.patientStoryBoard.instantiateViewController(withIdentifier: "DischargeWeb") as! DischargeWeb
        vc.titleString = ""
        vc.webUrlString = "\(SceneDelegate.GlobalVariables.dischargeJSON![sender.tag]["dischargeUrl"].stringValue)/\(SceneDelegate.GlobalVariables.userID)/\(patientID!)"
        self.navigationController!.pushViewController(vc, animated: true)
        
        onClickTransParentView()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
}//end ViewController

// MARK: - UICollectionViewDataSource

extension PatientDetail: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if (patientJSON != nil) {
            return patientJSON!.count
        }
        else{
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellArray = self.patientJSON![indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"PatientCell", for: indexPath) as! PatientCell
        
        cell.roundAndShadow()
        
        if detailType == .echo {
            cell.cellTitle.text = "ID: \(cellArray["id_vdo"].stringValue)"
            cell.cellDescription.text = "Label: \(cellArray["label"].stringValue)"
            cell.cellDate.text = "Date: \(cellArray["date"].stringValue)"
        }
        else if detailType == .discharge {
            cell.cellTitle.text = cellArray["dischargeName"].stringValue
            cell.cellDescription.isHidden = true
            cell.cellDate.text = "Date: \(cellArray["date"].stringValue)"
        }
        
        cell.cellBtn.addTarget(self, action: #selector(detailClick(_:)), for: .touchUpInside)
        
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension PatientDetail: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = collectionView.frame.width
        //let viewHeight = collectionView.frame.height
        return CGSize(width: viewWidth-10 , height:96)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

// MARK: - UICollectionViewDelegate

extension PatientDetail: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        //let cellArray = patientJSON![indexPath.item]
        
    }
    
    @IBAction func detailClick(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is UICollectionViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UICollectionViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = myCollectionView.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        print("Detail \(indexPath.section) - \(indexPath.item)")
        
        let cellArray = patientJSON![indexPath.item]
        
        if detailType == .echo {
            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "EchoDetail_2") as! EchoDetail_2
            vc.echoType = .patient
            vc.videoID = cellArray["id_vdo"].stringValue
            vc.patientID = patientID
            self.navigationController!.pushViewController(vc, animated: true)
        }
        else if detailType == .discharge {
            let vc = UIStoryboard.patientStoryBoard.instantiateViewController(withIdentifier: "DischargeWeb") as! DischargeWeb
            vc.titleString = cellArray["dischargeName"].stringValue
            vc.webUrlString = cellArray["dischargeUrl"].stringValue
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
}

