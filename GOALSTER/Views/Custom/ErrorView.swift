//
//  ErrorView.swift
//  Samokat
//
//  Created by Daniyar on 7/18/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ErrorView: UIView {
    var disableScroll: Bool?
    
    lazy var appName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: StaticSize.size(16), weight: .bold)
        label.textColor = .ultraGray
        label.text = "24Goals"
        return label
    }()
    
    lazy var errorImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "error")
        return view
    }()
    
    lazy var errorLabel: CustomLabelWithoutPadding = {
        let label = CustomLabelWithoutPadding()
        label.font = .systemFont(ofSize: StaticSize.size(16), weight: .medium)
        label.textColor = .lightGray
        label.textAlignment  = .center
        return label
    }()
    
    lazy var errorButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Try again".localized, for: .normal)
        view.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        return view
    }()
    
    lazy var errorStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [errorImage, errorLabel, errorButton])
        view.distribution = .equalSpacing
        view.axis = .vertical
        view.alignment = .center
        view.spacing = StaticSize.size(30)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        alpha = 0
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp(){
        addSubViews([appName, errorStack])
        
        appName.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(15))
            $0.centerX.equalToSuperview()
        })
        
        errorStack.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
        })
        
        errorImage.snp.makeConstraints({
            $0.size.equalTo(StaticSize.size(150))
        })
        
        errorLabel.snp.makeConstraints({
            $0.width.equalTo(StaticSize.size(174))
        })
        
        errorButton.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
    
    static func addToView(view: UIView? = nil, text: String = "Error uccured, please try egain".localized, withName: Bool = true, disableScroll: Bool = false){
        var view = view
        if view == nil {
            view = UIApplication.topViewController()?.view
        }
        let errorView = ErrorView()
        errorView.errorLabel.text = text
        errorView.appName.isHidden = !withName
        errorView.disableScroll = disableScroll
        
        view?.addSubview(errorView)
        errorView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            errorView.alpha = 1
        })
        
        if disableScroll, let superview = errorView.superview as? UIScrollView {
            superview.isScrollEnabled = false
        }
    }
    
    @objc func onTap(){
        let vc = self.viewContainingController()
        
        if let disableScroll = disableScroll, disableScroll, let superview = self.superview as? UIScrollView {
            superview.isScrollEnabled = true
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 0
        }, completion: {
            if $0 {
                self.removeFromSuperview()
                vc?.viewDidLoad()
            }
        })
    }
}
