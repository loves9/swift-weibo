//
//  NetWorkTools.swift
//  FSWeiBo
//
//  Created by LKLFS on 16/9/22.
//  Copyright © 2016年 LKLFS. All rights reserved.
//

import UIKit

import AFNetworking

class NetWorkTools: AFHTTPSessionManager {
    // 单例
    static let shareInstance: NetWorkTools = {
        let baseUrl = NSURL(string: "https://api.weibo.com/")
        let instance = NetWorkTools(baseURL: baseUrl as URL?, sessionConfiguration: URLSessionConfiguration.default)
        instance.responseSerializer.acceptableContentTypes = Set(["text/plain"])
        return instance
    }()
    
}
