//
//  ProfileTableViewController.swift
//  SwiftWB
//
//  Created by Apple on 17/6/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLoad
        {
            visitorView?.setupVisitorInfo("visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
            return
        }
    }
}
