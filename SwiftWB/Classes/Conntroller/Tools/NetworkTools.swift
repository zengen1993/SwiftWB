//
//  NetworkTools.swift
//  Swift第三方库封装
//
//  Created by Apple on 2017/7/20.
//  Copyright © 2017年 Apple. All rights reserved.
//  Swift 3.0 AFN封装

import UIKit
import AFNetworking
enum ZEHTTPMethod {
    case GET
    case POST
}
class NetworkTools: AFHTTPSessionManager {
    
    //单例
    static let shareInstance: NetworkTools = {
        
        let baseURL = URL(string: "https://api.weibo.com/")
        let instance = NetworkTools(baseURL: baseURL, sessionConfiguration: URLSessionConfiguration.default)
        
        instance.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain","text/html") as! Set
        
        return instance
        }()
    func login(_ uid: String,finished: @escaping (_ array: AnyObject?,_ error: Error?)->()){
        get(uid, parameters: nil, progress: nil, success: { (task, objc) in
            finished(objc as AnyObject, nil)
            
        }) { (task, error) in
            finished(nil, error)
        }
    }

    func loadStatuses(finished: @escaping (_ array:[[String: AnyObject]]?,_ error: Error?)->()){
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能获得微博数据")
        //路径
        let path = "2/statuses/home_timeline.json"
        //参数
        let parameters = ["access_token": UserAccount.loadUserAccount()?.access_token]
        print(parameters)
        //发送请求
        get(path, parameters: parameters, progress: nil, success: { (task, objc) in
            guard let arr = (objc as! [String: AnyObject])["statuses"] as? [[String: AnyObject]] else{
                finished(nil, NSError(domain: "www.baidu.com", code: 1000, userInfo: ["message": "没有获取到数据"]))
                return
            }
            
            finished(arr, nil)
        }) { (task, error) in
            finished(nil, error)
        }
    }
    // 将成功和失败的回调写在一个逃逸闭包中(请求)
    /// 封装 AFN 的 GET / POST 请求
    ///
    /// - parameter method:     GET / POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter completion: 完成回调[json(字典／数组), 是否成功]
    
    func request(requestType :ZEHTTPMethod, URLString: String,parameters: [String: AnyObject]?, completed:@escaping ((_ json: AnyObject?, _ Error: Error?)->())) {
        
        /// 定义成功回调闭包
        let success = { (task: URLSessionDataTask,objc: Any?)->() in
            guard objc != nil else {
                print("返回数据为空")
                return
            }
            completed(objc as AnyObject?,nil)
        }
        
        /// 定义失败回调闭包
        let failure = {(task: URLSessionDataTask?, error: Error)->() in
            completed(nil,error)
        }
        
        /// 通过请求方法,执行不同的请求
        if requestType == .GET { // GET
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
            
        } else { // POST
            
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
    
    // MARK: - 封装 AFN 方法
    /// 上传文件必须是 POST 方法，GET 只能获取数据
    /// 封装 AFN 的上传文件方法
    ///
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter name:       接收上传数据的服务器字段(name - 要咨询公司的后台) `pic`
    /// - parameter data:       要上传的二进制数据
    /// - parameter completion: 完成回调
    func unload(urlString: String, parameters: AnyObject?, constructingBodyWithBlock:((_ formData:AFMultipartFormData) -> Void)?, uploadProgress: ((_ progress:Progress) -> Void)?, success: ((_ responseObject:AnyObject?) -> Void)?, failure: ((_ error: NSError) -> Void)?) -> Void {
        
        
        NetworkTools.shareInstance.post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            
            
        }, progress: { (progress) in
            uploadProgress!(progress)
        }, success: { (task, objc) in
            if objc != nil {
                
                success!(objc as AnyObject?)
                
            }
        }, failure: { (task, error) in
            failure!(error as NSError)
            
        })
    }
}


