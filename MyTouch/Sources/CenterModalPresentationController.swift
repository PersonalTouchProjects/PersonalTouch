//
//  CenterModalPresentationController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/3/7.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit

class CenterModalPresentationController: UIPresentationController {
    
    private var insets = UIEdgeInsets(top: 32, left: 16, bottom: 16, right: 16)
    private var maxHeight = CGFloat(600)
    private var maxWidth = CGFloat(500)
    private var cornerRadius = CGFloat(10)
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.35)
        view.addGestureRecognizer(self.tapGestureRecognizer)
        return view
    }()
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        return recognizer
    }()
    
    var tapToDismiss = false
    
    // MARK: - UIPresentationController
    
    convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, insets: UIEdgeInsets, maxHeight: CGFloat = 500, maxWidth: CGFloat = 500, cornerRadius: CGFloat = 8) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.insets = insets
        self.maxHeight = maxHeight
        self.maxWidth = maxWidth
        self.cornerRadius = cornerRadius
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.presentedViewController.modalPresentationStyle = .custom
    }
    
    override func presentationTransitionWillBegin() {
        
        presentedView?.layer.masksToBounds = true
        presentedView?.layer.cornerRadius = cornerRadius
        presentedView?.layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        presentedView?.layer.shadowOffset = CGSize.zero
        presentedView?.layer.shadowOpacity = 0.15
        presentedView?.layer.shadowRadius = 2.0
        
        
        self.containerView?.addSubview(dimmingView)
        self.containerView?.sendSubviewToBack(dimmingView)
        dimmingView.frame = self.containerView?.bounds ?? CGRect.zero
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        dimmingView.alpha = 0.0
        
        let coordinator = self.presentingViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        
        let coordinator = self.presentingViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 0.0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        
        let size = CGSize(
            width: min(parentSize.width - insets.left - insets.right, maxWidth),
            height: min(parentSize.height - insets.top - insets.bottom, maxHeight)
        )
        
        return size
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        guard let containerView = self.containerView else {
            return CGRect.zero
        }
        
        let size = self.size(
            forChildContentContainer: self.presentedViewController,
            withParentContainerSize: containerView.bounds.size
        )
        
        let origin = CGPoint(
            x: (containerView.bounds.width - size.width - insets.left - insets.right) / 2 + insets.left,
            y: (containerView.bounds.height - size.height - insets.top - insets.bottom) / 2 + insets.top
        )
        
        return CGRect(origin: origin, size: size)
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    // MARK: - TapGesture
    
    @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        if tapToDismiss {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
}
