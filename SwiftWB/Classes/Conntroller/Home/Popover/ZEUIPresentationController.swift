//
//  ZEUIPresentationController.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class ZEUIPresentationController: UIPresentationController {
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    //用于布局转场动画弹出的控件
    override func containerViewWillLayoutSubviews(){
        presentedView?.frame = CGRect(x: (kWidth - 200)/2, y: 45, width: 200, height: 200)
        containerView?.insertSubview(coverBtn, at: 0)
        coverBtn.addTarget(self, action: #selector(ZEUIPresentationController.CoverClick), for: .touchUpInside)
    }
    func CoverClick(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    private lazy var coverBtn: UIButton = {
        let btn = UIButton()
        btn.frame = UIScreen.main.bounds
        return btn
    }()
    
}
