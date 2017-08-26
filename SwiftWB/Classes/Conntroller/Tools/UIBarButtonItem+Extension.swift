//
//  UIBarButtonItem+Extension.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

extension UIBarButtonItem
{
    // 2.依赖于指定构造方法
    convenience init(imageName: String, target: AnyObject?, action: Selector)
    {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        self.init(customView: btn)
    }
}
