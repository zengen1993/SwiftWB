//
//  UserAccount.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding{
    
    var access_token: String?
    var expires_in: Int = 0
//    var expires_Data: NSData?
    var uid: String?
    //  用户头像地址
    var avatar_large: String?
    //	用户昵称
    var screen_name: String?
    init(dict: [String: AnyObject]) {
        super.init()
        self.setValuesForKeys(dict)
    }
    
    // 当KVC发现没有对应的key时就会调用
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        return "Zengen"
    }
    //MARK: - 外部控制方法
    //归档模型
    func saveAccount()->Bool{
        //获取缓存目录路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        //生成缓存路径
        let filePath = (path as NSString).appendingPathComponent("useraccount.plist")
        //归档对象
        print(filePath)
        return NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
    }
    //定义属性保存授权模型
    static var Uaccount: UserAccount?
    
    //解档模型
    class func loadUserAccount() -> UserAccount?{
        
        //判断是否已经加载
        if Uaccount != nil{
            //直接返回
            return Uaccount
        }
        //获取缓存目录路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        //生成缓存路径
        let filePath = (path as NSString).appendingPathComponent("useraccount.plist")
        //归档对象
        print(filePath)
        guard let account = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserAccount else {

            return nil
        }
        Uaccount = account
        return Uaccount
    }
    //获取用户信息
    func loadUserInfo(finished: @escaping (_ account: UserAccount?, _ error: Error?)->()){
        //断言
        assert(access_token != nil, "使用方法必须先授权")
        let path = "2/users/show.json"
        let parameters = ["access_token": access_token, "uid": uid]
        NetworkTools.shareInstance.get(path, parameters: parameters, progress: nil, success: { (URLSessionDataTask, objc) in
            let dict = objc as! [String: Any]
            
            self.avatar_large = dict["avatar_large"] as! String
            self.screen_name = dict["screen_name"] as! String
            
//            self.saveAccount()
            finished(self, nil)
        }) { (URLSessionDataTask, error) in
            print(error)
            finished(nil, error)
        }
    }
    //判断用户是否登录
    class func isLogin()->Bool{
        return UserAccount.loadUserAccount() != nil
    }
    
    //MARK: - NSCoding
    func encode(with aCoder: NSCoder){
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    required init?(coder aDecoder: NSCoder){
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        self.expires_in = aDecoder.decodeInteger(forKey: "expires_in") as Int
        self.uid = aDecoder.decodeObject(forKey: "uid") as? String
        self.avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        self.screen_name = aDecoder.decodeObject(forKey:"screen_name") as? String
    }

}

