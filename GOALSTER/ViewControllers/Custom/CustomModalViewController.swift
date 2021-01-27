//
//  CustomModalViewController.swift
//  Samokat
//
//  Created by Daniyar on 7/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class CustomModalViewController: UIViewController{
    lazy var modalView = CustomModalView()
    
    var modalHeight: CGFloat!
    lazy var initialHeight: CGFloat = 0
    
    required init(modalHeight: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        
        self.modalHeight = modalHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanTray(sender:)))
        modalView.topSmallContainer.addGestureRecognizer(panGesture)
    }
    
    override func loadView() {
        super.loadView()
        
        view = modalView
    }
    
    func openContainer(completion: ((Bool) -> Void)? = nil){
        modalView.containerView.snp.updateConstraints({
            $0.height.equalTo(modalHeight)
        })
        
        UIView.animate(withDuration: 0.35, animations: {
            self.view.layoutIfNeeded()
            self.modalView.backDarkView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }, completion: completion)
    }
    
    @objc func didPanTray(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == UIGestureRecognizer.State.began {
            initialHeight = modalView.containerView.frame.height
        } else if sender.state == UIGestureRecognizer.State.changed {
            modalView.containerView.snp.updateConstraints({
                $0.height.equalTo(initialHeight - translation.y)
            })
        } else if sender.state == UIGestureRecognizer.State.ended {
            let velocity = sender.velocity(in: view)
            if velocity.y > 0{
                animateDown()
            } else {
                animateUp()
            }
        }
    }
    
    func animateUp(){
        modalView.containerView.snp.updateConstraints({
            $0.height.equalTo(modalHeight)
        })
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    func animateDown(onStart: (()->())? = nil){
        if let onStart = onStart{
            onStart()
            view.layoutIfNeeded()
        }
        
        modalView.containerView.snp.updateConstraints({
            $0.height.equalTo(0)
        })
        
        UIView.animate(withDuration: 0.35, animations: {
            self.view.layoutIfNeeded()
            self.modalView.backDarkView.backgroundColor = .clear
        }) { (finished) in
            self.remove()
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: view) else { return }
        if !modalView.containerView.frame.contains(location) {
            animateDown()
        }
    }
}

