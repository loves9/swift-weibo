//
//  BaseTableViewController.swift
//  FSWeiBo
//
//  Created by LKLFS on 16/7/27.
//  Copyright © 2016年 LKLFS. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    var isLogin = false
    
    var visitorView = VisitorView()

    override func loadView() {
        
        isLogin ? super.loadView() : setupVisitorView()
        
    }
    
    private func setupVisitorView()
    {
        // 1.创建访客视图
        visitorView = VisitorView.visitorView()
        view = visitorView
        
        // 2.设置代理
        visitorView.loginButton.addTarget(self, action: #selector(loginBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(registerBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        
        // 3.添加导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(registerBtnClick(btn:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(loginBtnClick(btn:)))
    }
    
    @objc private func loginBtnClick(btn: UIButton)
    {
        let login = OAuthViewController()
        present(login, animated: true, completion: nil)
        
    }
    @objc private func registerBtnClick(btn: UIButton)
    {
        FSLog(message: "register")
    }
}
