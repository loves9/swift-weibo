//
//  titleButton.swift
//  FSWeiBo
//
//  Created by LKLFS on 16/8/30.
//  Copyright © 2016年 LKLFS. All rights reserved.
//

import UIKit

class titleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        setImage(UIImage(named: "navigationbar_arrow_down"), for: UIControl.State.normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: UIControl.State.selected)
        
        setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        sizeToFit()
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        // ?? 用于判断前面的参数是否是nil, 如果是nil就返回??后面的数据, 如果不是nil那么??后面的语句不执行
        super.setTitle((title ?? "") + "  ", for: state)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.width
        
    }
}
