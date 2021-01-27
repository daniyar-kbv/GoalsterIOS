//
//  BaseViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    lazy var baseView = BaseView()
    var showGradient = true
    var action: Selector?
    
    override func loadView() {
        super.loadView()
        
        view = baseView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if showGradient{
            baseView.addGradientBackground()
        } else {
            baseView.backgroundColor = .white
        }
    }
    
    func setTitle(_ title: String){
        baseView.titleLabel.text = title
    }
    
    func addAddButton(action: Selector) {
        baseView.addButton.isHidden = false
        baseView.addButton.addTarget(self, action: action, for: .touchUpInside)
        self.action = action
    }
    
    func removeAddButton() {
        baseView.addButton.isHidden = true
        baseView.addButton.removeTarget(self, action: action, for: .touchUpInside)
        action = nil
    }
    
    func setView(_ view: UIView) {
        baseView.contentView.addSubview(view)
        
        view.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    func showBrush(){
        baseView.topBrush.isHidden = false
    }
}
