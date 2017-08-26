
//
//  HomeTableViewController.swift
//  SwiftWB
//
//  Created by Apple on 17/6/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
class HomeTableViewController: BaseTableViewController {
    var statuses: [StatusViewModel]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLoad{
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        //初始化导航条
        setupNav()
        NotificationCenter.default.addObserver(self, selector:Selector("titleChange"),
                                               name: ZEPresentationManagerDidPresented, object: animatorManager)
        NotificationCenter.default.addObserver(self, selector:Selector("titleChange"),
                                               name: ZEPresentationManagerDismissed, object: animatorManager)
        loadData()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let cellXIB = UINib.init(nibName: "HomeTableCell", bundle: Bundle.main)
        tableView.register(cellXIB, forCellReuseIdentifier: "HomeCell")
        

    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //获取微博首页数据
    func loadData(){
        NetworkTools.shareInstance.loadStatuses { (array, error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: "获取微博数据失败")
                return
            }
            
            guard let arr = array else{
                return
            }
            
            var models = [StatusViewModel]()
            for dict in arr
            {
                let status = Status(dict: dict)
                let viewModel = StatusViewModel(status: status)
                models.append(viewModel)
            }
            self.statuses = models
    
//            self.cachesImages(models)
        }
    }
    
    private func cachesImages(_ viewModels: [StatusViewModel]){
        
        let grounp = DispatchGroup()
        for viewModel in viewModels
        {
            guard let picurls = viewModel.thumbnail_pic else{
                //如果没有取到值，继续加载下一张
                continue
            }
            for dict in picurls{
                
                grounp.enter()
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: dict, options: SDWebImageDownloaderOptions(rawValue: 0), progress: nil, completed: { (image, _, error, _) in
                    print("图片下载完毕")
                    grounp.leave()
                })
            }
        }
        
        grounp.notify(queue: .main) {
            print("全部图片加载完毕")
            self.statuses = viewModels
        }
    }
    fileprivate func setupNav(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
        navigationItem.titleView = titleBtn
    }
    
    // MARK: - 懒加载
    private lazy var animatorManager = ZEPresentationManager()
    /// 标题按钮
    private lazy var titleBtn: NavTitleBtn = {
        let btn = NavTitleBtn()
        
        let title = UserAccount.loadUserAccount()?.screen_name
        btn.setTitle(title, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick), for: .touchUpInside)
        return btn
    }()

    // MARK: - 内部控制方法
    @objc private func leftBtnClick()
    {
       
    }
    @objc private func rightBtnClick()
    {
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        present(vc!, animated: true, completion: nil)
    }
    @objc private func titleChange(){
        titleBtn.isSelected = !titleBtn.isSelected
    }
    @objc private func titleBtnClick(){
        //创建菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController()
        else {return}
        //自定义转场动画
        //设置转场代理
        menuView.transitioningDelegate = animatorManager
        //设置动画样式
        menuView.modalPresentationStyle = UIModalPresentationStyle.custom
        //弹出菜单
        present(menuView, animated: true, completion: nil)
         
    }
}
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.statuses?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //取出Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableCell
        
        cell.viewModel = statuses![indexPath.row]

        return cell
    }
}
