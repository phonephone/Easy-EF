//
//  SceneDelegate.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 17/7/2565 BE.
//

import UIKit
import SwiftyJSON

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    struct GlobalVariables {
        static var userID = ""
        static var dischargeJSON:JSON? = nil
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        //UserDefaults.standard.removeObject(forKey:"userID")//อย่าลืมเอาออก
        var userID = UserDefaults.standard.string(forKey:"userID")
        //userID = "1"
        
        if userID != nil {
            print("USER ID = \(String(describing: userID))")
            GlobalVariables.userID = userID!
            setFirstPage(isLogedIn: true, scene:scene)
        }
        else{
            GlobalVariables.userID = ""
            setFirstPage(isLogedIn: false, scene:scene)
        }
    }
    
    func setFirstPage(isLogedIn:Bool, scene:UIScene) {
        var navigationController : UINavigationController
        
        if isLogedIn {
            print("Home")
            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "Home") as! Home
            navigationController = UINavigationController.init(rootViewController: vc)
        } else{
            print("Pre Login")
            let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "PreLogin") as! PreLogin
            navigationController = UINavigationController.init(rootViewController: vc)
        }
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            //let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let statusBar = UIView(frame: window.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = .red
            window.addSubview(statusBar)
            
            //***อย่าลืม
            //let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "Login") as! Login
            
            //let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "SignUp") as! SignUp
            
            //let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "Home") as! Home
            
            //let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "EchoInput") as! EchoInput
            //vc.videoID = "292"
            
//            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "EchoDetail") as! EchoDetail
//            vc.videoID = "1439"//OK
            //vc.videoID = "1444"//Error
            
            //let vc = UIStoryboard.patientStoryBoard.instantiateViewController(withIdentifier: "PatientList") as! PatientList
            
            //let vc = UIStoryboard.loginStoryBoard.instantiateViewController(withIdentifier: "ForgetPassword") as! ForgetPassword
            
            //let vc = UIStoryboard.patientStoryBoard.instantiateViewController(withIdentifier: "DischargeForm") as! DischargeForm
            //vc.dischargeType = .form3
            //vc.dischargeID = "19"
            
            //let vc = UIStoryboard.guideStoryBoard.instantiateViewController(withIdentifier: "Assessment1_1") as! Assessment1_1
            //let vc = UIStoryboard.guideStoryBoard.instantiateViewController(withIdentifier: "Assessment1_4") as! Assessment1_4
            //let vc = UIStoryboard.guideStoryBoard.instantiateViewController(withIdentifier: "Assessment_Web") as! Assessment_Web
            
//            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "EchoDetail_2") as! EchoDetail_2
//            vc.videoID = "1439"//OK
            
            //let vc = UIStoryboard.guideStoryBoard.instantiateViewController(withIdentifier: "Dose") as! Dose

            //navigationController = UINavigationController.init(rootViewController: vc)
            //***อย่าลืม
            
            navigationController.setNavigationBarHidden(true, animated:false)
            window.rootViewController = navigationController// Your RootViewController in here
            window.makeKeyAndVisible()
            self.window = window
        }
        //guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

