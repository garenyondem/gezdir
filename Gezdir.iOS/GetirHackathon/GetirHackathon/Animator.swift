//
//  Animator.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 25/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit

class Animator: UIPercentDrivenInteractiveTransition {
    
    var isPresenting = true
    
}

// MARK: - UIPercentDrivenInteractiveTransition
extension Animator {
    

}

// MARK: - UIViewControllerTransitioningDelegate
extension Animator: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }
}

extension Animator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        toView?.transform = CGAffineTransform(translationX: 0, y: -toView!.frame.height)
        containerView.addSubview(toView!)
        
        UIView.animate(withDuration: 0.5, animations: { 
            toView?.transform = CGAffineTransform.identity
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
