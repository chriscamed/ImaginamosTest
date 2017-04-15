//
//  FlipPresentAnimationController.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/14/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import Foundation
import UIKit

class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        
        let containerView = transitionContext.containerView
        
        let initialFrame = originFrame
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        snapshot?.frame = initialFrame
        //snapshot?.layer.cornerRadius = 25
        snapshot?.layer.cornerRadius = 0
        snapshot?.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot!)
        toVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransform(forContainerView: containerView)
        snapshot?.layer.transform = AnimationHelper.yRotation(angle: .pi/2)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
                    fromVC.view.layer.transform = AnimationHelper.yRotation(angle: -.pi/2)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                    snapshot!.layer.transform = AnimationHelper.yRotation(angle: 0.0)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                    snapshot?.frame = finalFrame
                })
        },
            completion: { _ in                
                toVC.view.isHidden = false
                fromVC.view.layer.transform = AnimationHelper.yRotation(angle: 0.0)
                snapshot?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
