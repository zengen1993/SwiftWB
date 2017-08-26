//
//  OAuthViewController.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD
//https://m.baidu.com/?code=8502fb57e6e25d13b43b9c054bd5028e&from=844b&vit=fps
class OAuthViewController: UIViewController {
    // 网页容器
    @IBOutlet weak var customWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=1507457636&redirect_uri=http://www.baidu.com"
        guard let url = URL(string: urlStr)
            else {
            return
        }
        let request = URLRequest(url: url)
        customWebView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

}
extension OAuthViewController: UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.showInfo(withStatus: "正在加载中...")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func  webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let urlStr = request.url?.absoluteString else {
            return false
        }
        if !urlStr.hasPrefix("http://www.baidu.com")
        {
            print("不是授权回调页")
            return true
        }
        print("是授权回调页")
        let key = "code="
        if urlStr.contains(key)
        {
            let code = request.url?.query?.substring(from: key.endIndex)
            
            loadAccessToken(codeStr: code)
            return false
        }
        print("授权失败")
        return false
    }
    private func loadAccessToken(codeStr: String?){
        
        guard let code = codeStr else {
            return
        }
        let path = "oauth2/access_token"
        
        let parameters = ["client_id": "1507457636","client_secret": "edfd621e43c75ad326f917bfe1f76957","grant_type": "authorization_code", "code": code,"redirect_uri": "http://www.baidu.com" ]
            print(code)
        NetworkTools.shareInstance.post(path, parameters: parameters, progress: nil, success: { (URLSessionDataTask, dict) in
            let account = UserAccount(dict: dict as! [String : AnyObject])
            
            account.loadUserInfo(finished: { (account, error) in
                //保存用户信息
                account?.saveAccount()
                //跳转到欢迎界面
                let sb = UIStoryboard(name:"Welcome", bundle: nil)
                let vc = sb.instantiateInitialViewController()
                UIApplication.shared.keyWindow?.rootViewController = vc
            })
        }) { (URLSessionDataTask, error) in
            print(error)
        }
    }
}
