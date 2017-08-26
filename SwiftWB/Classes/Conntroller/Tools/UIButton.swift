//
//  UIButton.swift
//  SwiftWB
//
//  Created by Apple on 17/6/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

extension UIButton{
    convenience init(ImageName: String, backgroundName: String)
    {
        self.init()
        setImage(UIImage(named: ImageName), for: .normal)
        setImage(UIImage(named: ImageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: backgroundName), for: .normal)
        setBackgroundImage(UIImage.init(named: backgroundName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
}
