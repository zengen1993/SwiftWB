//
//  ZEPresentationManager.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
//自定义转场通知
let ZEPresentationManagerDidPresented = NSNotification.Name(rawValue:"ZEPresentationManagerDidPresented")

let ZEPresentationManagerDismissed = NSNotification.Name(rawValue:"ZEPresentationManagerDismissed")

class ZEPresentationManager: NSObject, UIViewControllerTransitioningDelegate,
    UIViewControllerAnimatedTransitioning{
    private var isPresent = false
    //MARK: - UIViewControllerTransitioningDelegate
    //返回一个负责转场动画的对象
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?{
        
        return ZEUIPresentationController(presentedViewController: presented, presenting: presenting)
    }
    //返回一个负责如何出现的对象     
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        //发送一个通知，告诉调用者状态发生了改变
        NotificationCenter.default.post(name:ZEPresentationManagerDidPresented, object: self)
        
        isPresent = true
        return self
    }
    //返回一个负责如何消失的对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        NotificationCenter.default.post(name: ZEPresentationManagerDismissed, object: self)
        
        isPresent = false
        return self
    }

    //MARK: - UIViewControllerAnimatedTransitioning
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 2.0
    }
    //管理modal如何展现和消失
    //实现之后，系统不再会有默认动画了
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        //判断是展现还是消失
        if isPresent{
            willPresentedController(transitionContext: transitionContext)
        }else{
            willDismissedController(transitionContext: transitionContext)
        }
    }
    //展现动画
    private func willPresentedController(transitionContext: UIViewControllerContextTransitioning){
        //获取要弹出的视图
        guard let toVC = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        transitionContext.containerView.addSubview(toVC)
        //将要弹出的视图添加到containerView上
        toVC.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0)
        toVC.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        UIView.animate(withDuration: 1.0, animations: {
            toVC.transform = CGAffineTransform.identity
        }) { (_) in
            //一定要告诉系统动画执行完了，否则可能会引发未知的错误
            transitionContext.completeTransition(true)
        }
    }
    //消失动画
    private func willDismissedController(transitionContext: UIViewControllerContextTransitioning){
        //获取要消失的视图
        guard let fromVC = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            fromVC.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.00001)
        }, completion: { (_) in
            transitionContext.completeTransition(true)
        })
    }
}
