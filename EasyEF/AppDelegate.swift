//
//  AppDelegate.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 17/7/2565 BE.
//

import UIKit
import IQKeyboardManagerSwift
import ProgressHUD
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        IQKeyboardManager.shared.enable = true
        
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = .themeColor
        ProgressHUD.colorHUD = .white
        ProgressHUD.colorBackground = .clear//.lightGray
        ProgressHUD.colorStatus = .themeColor
        ProgressHUD.fontStatus = UIFont.Prompt_Medium(ofSize: 20)
        ProgressHUD.colorProgress = .themeColor
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

