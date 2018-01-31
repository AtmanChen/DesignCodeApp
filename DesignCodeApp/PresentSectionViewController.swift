//
//  PresentSectionViewController.swift
//  DesignCodeApp
//
//  Created by Huangyongle on 2018/1/31.
//  Copyright © 2018年 Meng To. All rights reserved.
//

import UIKit

class PresentSectionViewController: NSObject, UIViewControllerAnimatedTransitioning {
	
	
	var cellFrame: CGRect!
	var cellTransform: CATransform3D!
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.6
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let destionation = transitionContext.viewController(forKey: .to) as! SectionViewController
		let containerView = transitionContext.containerView
		containerView.addSubview(destionation.view)
		let widthConstraint = destionation.scrollView.widthAnchor.constraint(equalToConstant: 304)
		let heightConstraint = destionation.scrollView.heightAnchor.constraint(equalToConstant: cellFrame.size.height)
		let bottomConstraint = destionation.scrollView.bottomAnchor.constraint(equalTo: destionation.coverImageView.bottomAnchor)
		NSLayoutConstraint.activate([widthConstraint, heightConstraint/*, bottomConstraint]*/])
		let translate = CATransform3DMakeTranslation(cellFrame.origin.x, cellFrame.origin.y, 0.0)
		let transform = CATransform3DConcat(translate, cellTransform)
		destionation.view.layer.transform = transform
		destionation.view.layer.zPosition = 999
		containerView.layoutIfNeeded()
		
		destionation.scrollView.layer.cornerRadius = 14
		destionation.scrollView.layer.shadowOpacity = 0.25
		destionation.scrollView.layer.shadowOffset = CGSize(width: 0, height: 10)
		destionation.scrollView.layer.shadowRadius = 20
		
		let moveUpTransform = CGAffineTransform(translationX: 0, y: -100)
		let scaleUpTransform = CGAffineTransform(scaleX: 2, y: 2)
		let removeFromViewTransform = moveUpTransform.concatenating(scaleUpTransform)
		
		destionation.closeVisualEffectView.alpha = 0
		destionation.closeVisualEffectView.transform = removeFromViewTransform
		destionation.subHeadVisualEffectView.alpha = 0
		destionation.subHeadVisualEffectView.transform = removeFromViewTransform
		
		let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.7) {
			// final state
			NSLayoutConstraint.deactivate([widthConstraint, heightConstraint, bottomConstraint])
			destionation.view.layer.transform = CATransform3DIdentity
			containerView.layoutIfNeeded()
			destionation.scrollView.layer.cornerRadius = 0
			destionation.closeVisualEffectView.alpha = 1
			destionation.closeVisualEffectView.transform = .identity
			destionation.subHeadVisualEffectView.alpha = 1
			destionation.subHeadVisualEffectView.transform = .identity
			let scaleTitleTransform = CGAffineTransform(scaleX: 1.2, y: 1.2)
			let moveUpTitleTransform = CGAffineTransform(translationX: 30, y: 10)
			let titleTransform = scaleTitleTransform.concatenating(moveUpTitleTransform)
			destionation.titleLabel.transform = titleTransform
			
		}
		animator.addCompletion { _ in
			transitionContext.completeTransition(true)
		}
		animator.startAnimation()
	}
	
}
