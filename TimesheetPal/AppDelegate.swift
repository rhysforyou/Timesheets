//
//  AppDelegate.swift
//  TimesheetPal
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: Coordinator? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setHapticsEnabled(true)
        let navigationController = window!.rootViewController as! UINavigationController
        coordinator = Coordinator(navigationController)
        return true
    }

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
}

