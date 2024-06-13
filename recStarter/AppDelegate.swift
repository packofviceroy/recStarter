//
//  AppDelegate.swift
//  recStarter
//
//  Created by dumbo on 6/13/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var _window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        _window = UIWindow(frame: UIScreen.main.bounds)
        
        let _navigationController = UINavigationController(rootViewController: HomeViewController())
        _window?.rootViewController = _navigationController
        _window?.makeKeyAndVisible()
        
        
        return true
    }

}

