//
//  AppDelegate.swift
//  importfolio
//
//  Created by Marwan Osama on 03/09/2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20
        
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = BaseViewController.instantiate(from: .base)
//        let rootVC = UserViewController.instantiate(from: .user)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) { window?.overrideUserInterfaceStyle = .dark }
        
        return true
    }


}

