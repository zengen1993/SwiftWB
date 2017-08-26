//
//  VisitorView.swift
//  SwiftWB
//
//  Created by Apple on 17/6/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SDWebImage
class VisitorView: UIView {
    //注册按钮
    @IBOutlet weak var regusterBtn: UIButton!
    //登录按钮
    @IBOutlet weak var loginBtn: UIButton!
    //轮盘
    @IBOutlet weak var rotationImageView: UIImageView!
    //图标
    @IBOutlet weak var iconImageView: UIImageView!
    //文本
    @IBOutlet weak var titleLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
	
    }
    class func visitorView() -> VisitorView{
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.last as! VisitorView
    }
    
    /// 设置访客视图上的数据
    /// imageName需要显示的图标
    /// title需要显示的标题
    func setupVisitorInfo(_ imageName: String? ,title: String)
    {
        // 1.设置标题
        titleLabel.text = title
        
        // 2.判断是否是首页
        guard let name = imageName else
        {
            // 没有设置图标, 首页
            // 执行转盘动画
            startAniamtion()
            
            return
        }
        
        // 3.设置其他数据
        // 不是首页
        rotationImageView.isHidden = true
        iconImageView.image = UIImage(named: name)
        
    }
    
    // MARK: - 内部控制方法
    /// 转盘旋转动画
    private func startAniamtion()
    {
        // 1.创建动画
        let anim =  CABasicAnimation(keyPath: "transform.rotation")
        
        // 2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 5.0
        anim.repeatCount = MAXFLOAT
        
        // 注意: 默认情况下只要视图消失, 系统就会自动移除动画
        // 只要设置removedOnCompletion为false, 系统就不会移除动画
        anim.isRemovedOnCompletion = false
        
        // 3.将动画添加到图层上
        rotationImageView.layer.add(anim, forKey: nil)
    }
}
