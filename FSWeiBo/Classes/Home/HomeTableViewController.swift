//
//  HomeTableViewController.swift
//  FSWeiBo
//
//  Created by LKLFS on 16/7/25.
//  Copyright © 2016年 LKLFS. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.判断用户是否登录
        if !isLogin
        {
            // 设置访客视图
            visitorView.setupVisitorInfo(imageName: nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        // 2.设置导航
        setNavigator()
        
        // 注册通知 监听titlebutton 点击
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.titleChange), name: NSNotification.Name(rawValue: FSPresentationManagerDidPresented), object: animateManager)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.titleChange), name: NSNotification.Name(rawValue: FSPresentationManagerDismissed), object: animateManager)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setNavigator(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
        
        
        navigationItem.titleView = titleBtn
    }
    
    // MARK: - click
    @objc private func titleButtonClick(btn: titleButton){        
        // 2.创建菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        
        // 2.1 设置转场动画
        menuView.transitioningDelegate = animateManager
        menuView.modalPresentationStyle = UIModalPresentationStyle.custom
        present(menuView, animated: true) { 
            
        }
    }
    
    @objc private func leftBtnClick(){
    }
    
    @objc private func rightBtnClick(){
        
        // 1.创建扫一扫
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        
        // 2. 弹出
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc private func titleChange(){
        titleBtn.isSelected = !titleBtn.isSelected
    }
    // MARK: 懒加载 转场动画
    private lazy var animateManager : FSPresentationManager = {
        let pm = FSPresentationManager()
        pm.presentFrame = CGRect(x: MainScreenWidth()/5, y: 45, width: 200, height: 240)
        return pm
        
    }()
    
    private lazy var titleBtn: titleButton = {
        let btn = titleButton()
        btn.setTitle("博物馆ss", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(titleButtonClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
}



