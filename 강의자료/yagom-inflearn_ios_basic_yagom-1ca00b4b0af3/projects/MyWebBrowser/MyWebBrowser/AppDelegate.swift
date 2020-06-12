//
//  AppDelegate.swift
//  MyWebBrowser
//
//  Created by yagom
//  Copyright © 2017년 yagom. All rights reserved.
//

import UIKit

/// 마지막 페이지 주소를 UserDefaults에서 관리하기 위한 키 값
let lastPageURLDefualtKey: String = "lastURL"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?
    var lastPageURL: URL?

    // MARK: - Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.lastPageURL = UserDefaults.standard.url(forKey: lastPageURLDefualtKey)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        let userDefaults: UserDefaults
        userDefaults = UserDefaults.standard
        
        userDefaults.set(self.lastPageURL, forKey: lastPageURLDefualtKey)
        userDefaults.synchronize()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

