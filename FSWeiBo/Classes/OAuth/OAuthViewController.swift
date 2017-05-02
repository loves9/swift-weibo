//
//  OAuthViewController.swift
//  FSWeiBo
//
//  Created by LKLFS on 16/9/20.
//  Copyright © 2016年 LKLFS. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.创建webView
        view.addSubview(webView)
        
        // 2.加载登陆界面
        let oauthUrlStr = "https://api.weibo.com/oauth2/authorize?client_id=1052156984&redirect_uri=http://www.baidu.com"
        guard let url = NSURL(string: oauthUrlStr) else {
            return
        }
        
        let request = NSURLRequest(url: url as URL)
        webView.loadRequest(request as URLRequest)
        
    }

    // webView
    private lazy var webView: UIWebView = {
        var webview = UIWebView()
        webview.delegate = self
        webview.frame = CGRect.init(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        return webview
    }()
    
}

//MARK: - 代理方法
extension OAuthViewController: UIWebViewDelegate
{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        
        guard let urlStr = request.url?.absoluteString else {
            return true
        }
        
        if !(urlStr.hasPrefix("http://www.baidu.com/")) {
            FSLog(message: "不是授权回调页！")
            return true
        }
        
        let keyCode = "code="
        guard let query = request.url?.query else {
            return true
        }
        
        if (urlStr.contains(keyCode)) {
            // 拿到code
            let codeStr = query.substring(from: keyCode.endIndex)
            
            loadAccessToken(codeStr: codeStr)
            return false
        }
        
        return false
    }
    
    private func loadAccessToken(codeStr: String){
        // 请求路径
        let urlStr = "oauth2/access_token"
        
        // 请求参数
        let appKey = "1052156984"
        let appSecret = "d4fca7800335e384edb24ff6cffba88a"
        
        let paramter = ["client_id"    : appKey,
                        "client_secret": appSecret,
                        "grant_type"   : "authorization_code",
                        "code"         : codeStr,
                        "redirect_uri" : "http://www.baidu.com"]
        // 发送请求
        NetWorkTools.shareInstance.post(urlStr, parameters: paramter, progress: nil,
            success: { (task:URLSessionDataTask, respone) in

                
                print(respone!)
            },
            failure: { (task:URLSessionDataTask?, Error) in
                print(Error)
        })
        
    }
}
