//
//  VisitorView.swift
//  FSWeiBo
//
//  Created by LKLFS on 16/7/27.
//  Copyright © 2016年 LKLFS. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    var registerButton: UIButton = UIButton(frame: CGRect(x: 4,y: 300,width: 50,height: 50))
    
    var loginButton: UIButton = UIButton(frame: CGRect(x: MainScreenWidth()-50,y: 300,width: 50,height: 50))
    
    var rotationImageView: UIImageView = UIImageView(frame: CGRect(x: MainScreenWidth()/2 - 40,y: 80,width: 80,height: 80))
    
    var iconImageView: UIImageView = UIImageView(frame: CGRect(x: MainScreenWidth()/2 - 40,y: 80,width: 80,height: 80))
    
    var titleLabel: UILabel = UILabel(frame: CGRect(x: MainScreenWidth()/2 - 80,y: 200,width: 160,height: 120))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        self.addSubview(titleLabel)
        
        self.addSubview(iconImageView)

        rotationImageView.backgroundColor = UIColor.blue
        rotationImageView.image = UIImage(named:"visitordiscover_feed_image_smallicon")
        self.addSubview(rotationImageView)
        
        registerButton.setTitle("注册", for: UIControlState.normal)
        registerButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        registerButton.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: UIControlState.normal)
        self.addSubview(registerButton)
        
        loginButton.setTitle("登陆", for: UIControlState.normal)
        loginButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        loginButton.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: UIControlState.normal)
        self.addSubview(loginButton)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)! 
    } 
    
    
    func setupVisitorInfo(imageName: String? , title: String)
    {
        // 1.设置标题
        titleLabel.text = title
        
        guard let name = imageName else
        {
            // 2. 动画
            startAnimated()
            return
        }
        
        // 3.设置其他数据
        // 不是首页
        rotationImageView.isHidden = true
        
        iconImageView.image = UIImage(named: name)
    }
    
    private func startAnimated()
    {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 5.0
        anim.repeatCount = MAXFLOAT
        
        // 注意: 默认情况下只要视图消失, 系统就会自动移除动画
        // 只要设置removedOnCompletion为false, 系统就不会移除动画
        anim.isRemovedOnCompletion = false
        
        // 3.将动画添加到图层上
        rotationImageView.layer.add(anim, forKey: nil)
        
    }
    

    class func visitorView() -> VisitorView {
        let centerView = VisitorView(frame: CGRect(x: 0,y: 0,width:MainScreenWidth() ,height: MainScreenHeight()))
//        centerView.backgroundColor = UIColor.init(red: 200/255, green: 45/255, blue: 186/255, alpha: 1)
        centerView.backgroundColor = UIColor.lightText
        
        return centerView
    }

}
