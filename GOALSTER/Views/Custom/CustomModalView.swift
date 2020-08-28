//
//  CustomModalView.swift
//  Samokat
//
//  Created by Daniyar on 7/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CustomModalView: UIView{
    lazy var backDarkView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.1
        view.backgroundColor = .white
        return view
    }()
    
    lazy var mainContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var topSmallContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var topBrush: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([backDarkView, containerView])
        
        backDarkView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        containerView.snp.makeConstraints({
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0)
        })
        
        containerView.addSubViews([topSmallContainer, mainContainer])
        
        topSmallContainer.snp.makeConstraints({
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(StaticSize.size(20))
        })
        
        topSmallContainer.addSubViews([topBrush])
        topBrush.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(5)
            $0.width.equalTo(45)
            $0.centerX.equalToSuperview()
        })
        
        mainContainer.snp.makeConstraints({
            $0.top.equalTo(topSmallContainer.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        })
    }
    
    func setView(view: UIView){
        mainContainer.addSubview(view)
        view.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}

