//
//  NavTitleBtn.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class NavTitleBtn: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    fileprivate func setupUI()
    {
        setImage(UIImage(named: "navigationbar_arrow_down"), for: UIControlState())
        setImage(UIImage(named: "navigationbar_arrow_up"), for: UIControlState.selected)
        
        setTitleColor(UIColor.darkGray, for: UIControlState())
        sizeToFit()
    }
    override func setTitle(_ title: String?, for state: UIControlState) {
        // ?? 用于判断前面的参数是否是nil, 如果是nil就返回??后面的数据, 如果不是nil那么??后面的语句不执行
        super.setTitle((title ?? "") + "  ", for: state)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = self.frame.size.width - 19
    }
}
