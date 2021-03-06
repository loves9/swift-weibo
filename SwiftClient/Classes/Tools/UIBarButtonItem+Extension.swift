//
//  UIBarButtonItem+Extension.swift
//  FSWeiBo
//
//  Created by LKLFS on 16/8/30.
//  Copyright © 2016年 LKLFS. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName: String, target: AnyObject?, action: Selector){
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: UIControl.State.highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        self.init(customView: btn)
    }
}
