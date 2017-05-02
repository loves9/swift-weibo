//
//  AppDelegate.swift
//  FSWeiBo
//
//  Created by LKLFS on 16/7/22.
//  Copyright © 2016年 LKLFS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool
    {

        // 1. 创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        // 2. 设置根控制器
        window?.rootViewController = MainViewController()
        
        // 3. 显示window
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange

        return true
    }


}

func MainScreenWidth() -> CGFloat {
    let mainWidth = UIScreen.main.bounds.width
    return mainWidth
}

func MainScreenHeight() -> CGFloat {
    let mainWidth = UIScreen.main.bounds.height
    return mainWidth
}

func FSLog<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)
{
    #if DEBUG
        print("\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

