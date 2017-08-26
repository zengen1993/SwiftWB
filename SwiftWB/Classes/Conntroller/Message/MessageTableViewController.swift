//
//  MessageTableViewController.swift
//  SwiftWB
//
//  Created by Apple on 17/6/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class MessageTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLoad
        {
            visitorView?.setupVisitorInfo("visitordiscover_image_message", title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
            return
        }
    }
}
