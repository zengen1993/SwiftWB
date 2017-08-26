//
//  DiscoverTableViewController.swift
//  SwiftWB
//
//  Created by Apple on 17/6/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLoad
        {
            visitorView?.setupVisitorInfo("visitordiscover_image_message", title: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
            return
        }
    }
}
