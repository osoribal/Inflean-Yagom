//
//  AppDelegate.swift
//  MyLoginFlow
//
//  Created by 맥북 on 04/05/2020.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("[App Delegate] 어플리케이션이 실행되기 직전")
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("[App Delegate] 어플리케이션이 실행된 직후")
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("[App Delegate] 어플리케이션이 비활성화 될 예정")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("[App Delegate] 어플리케이션이 백그라운드로 진입함")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("[App Delegate] 어플리케이션이 백그라운드에서 벗어날 예정")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("[App Delegate] 어플리케이션이 활성화됨")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("[App Delegate] 어플리케이션이 종료되기 직전")
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

