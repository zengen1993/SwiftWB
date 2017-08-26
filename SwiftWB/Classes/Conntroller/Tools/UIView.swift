//
//  UIView.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

extension UIView{
    //一个view的底部
    func viewBottomY() ->CGFloat {
        let y = self.frame.origin.y + self.frame.size.height
        return y
    }
    
    //一个view的右边
    func viewRightX() ->CGFloat {
        let x = self.frame.origin.x + self.frame.size.width
        return x
    }
}
