//
//  FSPresentationManager.swift
//  FSWeiBo
//
//  Created by LKLFS on 16/9/7.
//  Copyright © 2016年 LKLFS. All rights reserved.
//

import UIKit

let FSPresentationManagerDidPresented = "FSPresentationManagerDidPresented"
let FSPresentationManagerDismissed = "FSPresentationManagerDismissed"


class FSPresentationManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate
{
    // 展现、消失标识
    private var isPresent = false;
    
    var presentFrame = CGRect.zero
    
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        let pc = FSPresentationController(presentedViewController: presented, presenting: presenting)
        pc.presentFrame = presentFrame
        
        return pc
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = true
        
        // 发送通知 通知状态改变
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: FSPresentationManagerDidPresented), object: self)
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: FSPresentationManagerDismissed), object: self)
        return self
        
    }
    
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        if isPresent {
            willPresentedController(transitionContext: transitionContext)
        } else {
            willDismissedController(transitionContext: transitionContext)
        }
    }
    
    /**
     *  出现动画
     */
    private func willPresentedController(transitionContext: UIViewControllerContextTransitioning){
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        transitionContext.containerView.addSubview(toView)
        
        // 动画
        toView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        // 设置锚点
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.transform = CGAffineTransform.identity
        }) { (true) in
            transitionContext.completeTransition(true)
        }
    }
    
    /**
     *  消失动画
     */
    
    private func willDismissedController(transitionContext: UIViewControllerContextTransitioning){
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0001)
            }, completion: { (true) in
                transitionContext.completeTransition(true)
        })
    }
}

