//
//  UIButton+Extension.swift
//  FSWeiBo
//
//  Created by LKLFS on 16/7/26.
//  Copyright © 2016年 LKLFS. All rights reserved.
//

import UIKit

extension UIButton
{
    convenience init(imageName: String, backgroundImageName: String)
    {
        self.init()
        
        // 2.设置前景图片
        setImage(UIImage(named: "tabbar_compose_icon_add"), for: UIControl.State.normal)
        setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: UIControl.State.highlighted)
        // 3.设置背景图片
        setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: UIControl.State.normal)
        setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: UIControl.State.highlighted)
        
        // 4.调整按钮尺寸
        sizeToFit()
    }
}
