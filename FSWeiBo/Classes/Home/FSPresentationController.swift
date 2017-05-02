//
//  FSPresentationController.swift
//  FSWeiBo
//
//  Created by LKLFS on 16/8/31.
//  Copyright © 2016年 LKLFS. All rights reserved.
//

import UIKit

class FSPresentationController: UIPresentationController {
    
    var presentFrame = CGRect.zero
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = presentFrame
        
        // 添加蒙版
        containerView?.insertSubview(coverBtton, at: 0)
        coverBtton.addTarget(self, action: #selector(coverBtnClick), for: UIControlEvents.touchUpInside)
    }
    
    // 懒加载 button
    private lazy var coverBtton : UIButton = {
        let button = UIButton()
        button.frame = UIScreen.main.bounds
        return button
    }()
    
    // coverbutton click
    @objc private func coverBtnClick(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
