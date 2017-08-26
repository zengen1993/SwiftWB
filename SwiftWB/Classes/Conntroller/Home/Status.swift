 //
//  Status.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class Status: NSObject{
    //微博创建时间
    var created_at: String?
    //微博ID
    var idstr: String?
    //微博正文
    var text: String?
    //微博来源
    var source: String?
    
    var user: StatusUser?
    //微博图片
//    var pic_urls: [[String: AnyObject]]?
    
    init(dict: [String: AnyObject]){
        super.init()
        setValuesForKeys(dict)
    }
    // setValuesForKeys会调用这句话
  
    override func setValue(_ value: Any?, forKey key: String) {
        // 1.拦截user赋值操作
        if key == "user"{
            user = StatusUser(dict: value as! [String : AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    // 当KVC发现没有对应的key时就会调用
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let property = ["created_at","idstr","text","source"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }
}
