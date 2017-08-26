
//
//  MainViewController.swift
//  SwiftWB
//
//  Created by Apple on 17/6/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewControllers()
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.addSubview(composeButton)
        let rect = composeButton.frame.size
        let width = tabBar.bounds.width/CGFloat(childViewControllers.count)
        composeButton.frame = CGRect(x: width * 2, y: 0, width: width, height: rect.height)
        
    }
    func addChildViewControllers(){
        //加载JSON数据
        guard let filePath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else{
            print("文件不存在")
            return
        }
        guard let data = NSData(contentsOfFile: filePath) else{
            print("获取二进制数据失败")
            return
        }
        
        do {     
            let obj = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! [[String: AnyObject]]
            for dict in obj{
                //遍历创建控制器
                let name = dict["title"] as? String
                let Image = dict["imageName"] as? String
                let vcName = dict["vcName"] as? String
                addChildViewController(vcName , title: name , ImageName: Image)
            }
        }
        catch{
            addChildViewController("HomeTableViewController", title: "首页", ImageName: "tabbar_home")
            addChildViewController("MessageTableViewController", title: "消息", ImageName: "tabbar_message_center")
            addChildViewController("NullViewController", title: "", ImageName: "")
            addChildViewController("DiscoverTableViewController", title: "发现", ImageName: "tabbar_discover")
            addChildViewController("ProfileTableViewController", title: "我", ImageName: "tabbar_profile")
        }
    }
    func addChildViewController(_ childController: String?, title: String?, ImageName: String?) {
        
        guard let name = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String  else {
            print("获取命名空间失败")
            return
        }
        var cls: AnyClass? = nil
        if let vName = childController{
            cls = NSClassFromString(name + "." + vName)
        }
        
        guard let Typecls = cls as? UITableViewController.Type else {
            print("cls不能当做UITableViewController")
            return
        }
        let childController = Typecls.init()
        print(childController)
        
        
        childController.navigationItem.title = title
        childController.tabBarItem.title = title
        if let ivName = ImageName{
            childController.tabBarItem.image = UIImage.init(named: ivName)
            childController.tabBarItem.selectedImage = UIImage.init(named: ivName + "_hightlighted")
        }
        let nav = UINavigationController(rootViewController: childController)

        addChildViewController(nav)
    }
    lazy var composeButton: UIButton = {
        ()-> UIButton
        in
        let btn = UIButton(ImageName: "tabbar_compose_icon_add", backgroundName: "tabbar_compose_button")
//        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal)
//        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), for: .highlighted)
//        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), for: .normal)
//        btn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button_highlighted"), for: .highlighted)
//        
//        btn.sizeToFit()
        btn.addTarget(self, action: Selector("btnClick"), for: .touchUpInside)
        return btn
    }()
    func getJSONStringFromDictionary(dictionary:[String: Any]) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }

    func btnClick(){
        print(123)
        let url = "http://192.168.1.153:8080/test/api/center.do"
        var param1 = [String: Any]()
        param1["method"] = "HAHAA"
        var param2 = [String: Any]()
        let name = "方法"
        let NameContext = name.addingPercentEscapes(using: String.Encoding.utf8)
        param2["ZS"] = "方法"
        print(NameContext)
        param2["WS"] = 2
        var data = [String: Any]()
        var para = [String: Any]()
        data["header"] = param1
        data["data"] = param2
        let JOSNStr = getJSONStringFromDictionary(dictionary: data)
        print()
        NetworkTools.shareInstance.post(url, parameters: JOSNStr, progress: { (_) in
            
        }, success: { (task, data) in
            print(data)
        }) { (task, error) in
            print(error)
        }
    }
}
