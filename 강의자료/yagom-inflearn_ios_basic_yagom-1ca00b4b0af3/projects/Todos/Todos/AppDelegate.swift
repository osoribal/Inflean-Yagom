//
//  AppDelegate.swift
//  Todos
//
//  Created by yagom on 2017
//  Copyright © 2017년 yagom. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    // 애플리케이션 실행 직후 호출
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // User Notification Center를 통해서 노티피케이션 권한 획득
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [UNAuthorizationOptions.alert, UNAuthorizationOptions.sound, UNAuthorizationOptions.badge]) { (granted, error) in
            print("허용여부 \(granted), 오류 : \(error?.localizedDescription ?? "없음")")
        }
       
        // 맨 처음 화면의 뷰 컨트롤러(TodosTableViewController)를 UserNotificationCenter의 delegate로 설정
        if let navigationController: UINavigationController = self.window?.rootViewController as? UINavigationController,
            let todosTableViewController: TodosTableViewController = navigationController.viewControllers.first as? TodosTableViewController {

            UNUserNotificationCenter.current().delegate = todosTableViewController
        }
        
        return true
    }
    
}

