//
//  MessageTableViewController.swift
//  XMGWB
//
//  Created by xiaomage on 15/12/1.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit

class MessageTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin
        {
            visitorView.setupVisitorInfo(imageName: "visitordiscover_image_message", title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
            return
        }
    }

}
