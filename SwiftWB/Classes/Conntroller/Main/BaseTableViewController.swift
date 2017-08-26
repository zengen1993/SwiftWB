//
//  BaseTableViewController.swift
//  SwiftWB
//
//  Created by Apple on 17/6/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    let isLoad = UserAccount.isLogin()
    //访客视图
    var visitorView: VisitorView?
    
    override func loadView() {
        isLoad ? super.loadView() : setupVisitorView()
    }
    private func setupVisitorView(){
         // 1.创建访客视图
        visitorView = VisitorView.visitorView()
        view = visitorView
        
        // 2.设置代理
        visitorView?.loginBtn.addTarget(self, action: #selector(BaseTableViewController.loginBtnClick), for: .touchUpInside)
        visitorView?.regusterBtn.addTarget(self, action: #selector(BaseTableViewController.registerBtnClick), for: .touchUpInside)
        
        // 3.添加导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseTableViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseTableViewController.loginBtnClick))
    }
    /// 监听登录按钮点击
    func loginBtnClick()
    {
        let sb = UIStoryboard(name: "OAuth", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        present(vc!, animated: true, completion: nil)
    }
    /// 监听注册按钮点击
    func registerBtnClick()
    {
       
    }

}
