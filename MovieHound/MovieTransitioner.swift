//
//  MovieTransitioner.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/13/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import UIKit

class MovieAnimatedTransitioner: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresentation = false // will check if we are transitioning to our overview or dismissing it

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let fromView = fromVC!.view

        let toVC = transitionContext.viewController(forKey: .to)
        let toVeiw = toVC!.view

        let containerView = transitionContext.containerView

        if isPresentation {
            containerView.addSubview(toVeiw!)
        }
        let animatingVC = isPresentation ? toVC : fromVC

        let animatingView = animatingVC!.view

        let appearedFrame = transitionContext.finalFrame(for: animatingVC!)
        var dismissedFrame = appearedFrame
        //moving the dismissed frame equal to its height, to remove it from the screen
        dismissedFrame.origin.y += dismissedFrame.size.height

        let initialPresentation = isPresentation ? dismissedFrame : appearedFrame
        let finalFrame = isPresentation ? appearedFrame : dismissedFrame

        animatingView?.frame = finalFrame

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 300, initialSpringVelocity: 5, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            animatingView?.frame = finalFrame

            if !self.isPresentation{
                animatingView?.alpha = 0
            }

        }) {(sucessBool: Bool) in
            if !self.isPresentation{
                fromView?.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        }
    }
}

class MovieTranstionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = MoviePresentationController(presentedViewController: presented, presenting: presenting)

        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = MovieAnimatedTransitioner()
        animationController.isPresentation = true

        return animationController
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = MovieAnimatedTransitioner()
        animationController.isPresentation = false

        return animationController
    }
}
