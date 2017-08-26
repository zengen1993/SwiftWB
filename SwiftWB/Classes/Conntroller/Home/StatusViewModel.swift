//
//  StatusViewModel.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
/*
M:  模型
V:  视图
C:  控制器
VM:
作用: 1.可以对M和V进行瘦身
     2.处理业务逻辑
*/

class StatusViewModel: NSObject {
    /// 模型对象
    var status: Status
    
    init(status: Status)
    {
        self.status = status
        
        // 处理头像
        icon_URL = URL(string: status.user?.profile_image_url ?? "")
        
        // 处理会员图标
        if (status.user?.mbrank)! >= 1 && (status.user?.mbrank)! <= 6
        {
            mbrankImage = UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
        }
        
        // 处理认证图片
        switch status.user?.verified_type ?? -1
        {
        case 0:
            verified_image = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verified_image = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verified_image = UIImage(named: "avatar_grassroot")
        default:
            verified_image = nil
        }
        // 处理来源
        if let sourceStr: NSString = status.source as! NSString, sourceStr != ""
        {
            let startIndex = (sourceStr as NSString).range(of: ">").location + 1
            
            let length = (sourceStr as NSString).range(of: "<", options: NSString.CompareOptions.backwards).location - startIndex
            
            let rest = (sourceStr as NSString).substring(with: NSMakeRange(startIndex, length))
            
            source_Text = "来自: " + rest
        }
        
        // 处理时间
        // "Sun Dec 06 11:10:41 +0800 2015"
        if let timeStr = status.created_at, timeStr != ""
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "EE MM dd HH:mm:ss Z yyyy"
            // 转换区域
            formatter.locale = Locale(identifier: "en")
            // 发布微博时间
            let createDate = formatter.date(from: timeStr)
            
            //与现在时间相隔多少
            let interval = -Int((createDate?.timeIntervalSinceNow)!)
            if interval < 60{
                created_Time = "刚刚"
            }else if interval < 60 * 60{
                created_Time = "\(interval/60)分钟前"
                
            }else if interval < 60 * 60 * 24{
                created_Time = "\(interval/(60 * 60))小时前"
            }else{
                created_Time = "\(createDate ?? nil)"
            }
        }
    }
    
    /// 用户认证图片
    var verified_image: UIImage?
    
    /// 会员图片
    var mbrankImage: UIImage?
    
    /// 用户头像URL地址
    var icon_URL: URL?
    
    /// 微博格式化之后的创建时间
    var created_Time: String = ""
    
    /// 微博格式化之后的来源
    var source_Text: String = ""
    
    /// 保存所有配图URL
    var thumbnail_pic: [URL]?
}

