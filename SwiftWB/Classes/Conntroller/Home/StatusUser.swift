//
//  StatusUser.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class StatusUser: NSObject {
    /// 字符串型的用户UID
    var idstr: String?
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    
    /// 用户认证类型
    var verified_type: Int = -1
    /// 用户会员等级
    var mbrank: Int = -1
    
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let property = ["idstr", "screen_name", "profile_image_url", "verified_type", "mbrank"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }
    
}
