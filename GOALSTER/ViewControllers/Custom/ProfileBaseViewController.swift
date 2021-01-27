//
//  ProfileBaseViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ProfileBaseViewController: UIViewController {
    lazy var baseView = ProfileBaseView()
    var showGradient = true
    var action: Selector?
    
    override func loadView() {
        super.loadView()
        
        view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
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
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func setView(_ view: UIView) {
        baseView.contentView.addSubview(view)
        
        view.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}

