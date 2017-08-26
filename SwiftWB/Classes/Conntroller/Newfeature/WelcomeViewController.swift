//
//  WelcomeViewController.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {
    //头像底部约束
    @IBOutlet weak var iconBottomCons: NSLayoutConstraint!
    //头像
    @IBOutlet weak var iconImageView: UIImageView!
    //欢迎文本
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImageView.layer.cornerRadius = 45
        guard let url = URL(string: (UserAccount.loadUserAccount()?.avatar_large)!) else {
            return
        }
        iconImageView.sd_setImage(with: url)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StartAnimation()

    }
    func StartAnimation(){
      
        self.iconBottomCons.constant = kHeight - iconBottomCons.constant
        view.layoutIfNeeded()
        //执行扫描动画
        UIView.animate(withDuration: 2.0, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            
            UIView.animate(withDuration: 2.0, animations: { 
                self.titleLabel.alpha = 1.0
            }, completion: { (_) in
                //跳转到首页
                let vc = MainViewController()
                UIApplication.shared.keyWindow?.rootViewController = vc 
            })
        }
    }
}
