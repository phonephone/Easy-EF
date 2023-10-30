//
//  PatientList.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 26/8/2565 BE.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class PatientList: UIViewController  {
    
    var patientJSON:JSON?
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
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
        
        loadList()
    }
    
    func loadList() {
        let parameters:Parameters = ["id_user":SceneDelegate.GlobalVariables.userID]
        loadRequest(method:.post, apiName:"Patients/ListV2", authorization:false, showLoadingHUD:true, dismissHUD:true, parameters: parameters){ result in
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
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
}//end ViewController

// MARK: - UICollectionViewDataSource

extension PatientList: UICollectionViewDataSource {
    
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
        
        cell.cellTitle.text = "ID: \(cellArray["id_patients"].stringValue)"
        cell.cellDescription.text = "Label: \(cellArray["label_patients"].stringValue)"
        
        cell.cellBtn.addTarget(self, action: #selector(echoClick(_:)), for: .touchUpInside)
        cell.cellBtn2.addTarget(self, action: #selector(dischargeClick(_:)), for: .touchUpInside)
        
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension PatientList: UICollectionViewDelegateFlowLayout {

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
        return CGSize(width: viewWidth-10 , height:100)
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

extension PatientList: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        //let cellArray = patientJSON![indexPath.item]
        
    }
    
    @IBAction func echoClick(_ sender: UIButton) {
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
        //print("Detail \(indexPath.section) - \(indexPath.item)")
        
        let cellArray = patientJSON![indexPath.item]
        let vc = UIStoryboard.patientStoryBoard.instantiateViewController(withIdentifier: "PatientDetail") as! PatientDetail
        vc.detailType = .echo
        vc.patientID = cellArray["id_patients"].stringValue
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func dischargeClick(_ sender: UIButton) {
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
        //print("Detail \(indexPath.section) - \(indexPath.item)")
        
        let cellArray = patientJSON![indexPath.item]
        let vc = UIStoryboard.patientStoryBoard.instantiateViewController(withIdentifier: "PatientDetail") as! PatientDetail
        vc.detailType = .discharge
        vc.patientID = cellArray["id_patients"].stringValue
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
