//
//  ViewWithBrush.swift
//  GOALSTER
//
//  Created by Dan on 2/3/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ViewWithBrush: UIView {
    lazy var topBrush: UIView = {
        let view = UIView()
        view.backgroundColor = .strongGray
        view.layer.cornerRadius = StaticSize.size(1.75)
        return view
    }()
    
    lazy var mainContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews([mainContainer, topBrush])
        
        mainContainer.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        topBrush.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(6))
            $0.width.equalTo(StaticSize.size(36))
            $0.height.equalTo(StaticSize.size(3.5))
            $0.centerX.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class View: ViewWithBrush {
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    lazy var backButton: BackButton = {
        let view = BackButton()
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(32), weight: .black)
        view.textColor = .deepBlue
        view.numberOfLines = 0
        return view
    }()
    
    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(16), weight: .medium)
        view.textColor = .middleGray
        view.numberOfLines = 0
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    required init(withBackButton: Bool = false, iconImage: UIImage? = nil) {
        super.init(frame: .zero)
        
        iconView.image = iconImage
        backgroundColor = .arcticWhite
        
        if withBackButton {
            mainContainer.addSubViews([backButton])
            
            backButton.snp.makeConstraints({
                $0.top.equalToSuperview().offset(StaticSize.size(25))
                $0.left.equalToSuperview().offset(StaticSize.size(7))
                $0.size.equalTo(StaticSize.size(30))
            })
        }
        
        mainContainer.addSubViews([backButton, iconView, titleLabel, subtitleLabel, contentView])
        
        titleLabel.snp.makeConstraints({
            $0.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        if withBackButton {
            backButton.snp.makeConstraints({
                $0.top.equalToSuperview().offset(StaticSize.size(30))
                $0.left.equalToSuperview().offset(StaticSize.size(15))
                $0.size.equalTo(StaticSize.size(30))
            })
            
            if iconImage != nil {
                iconView.snp.makeConstraints({
                    $0.left.equalTo(backButton.snp.right).offset(StaticSize.size(8))
                    $0.centerY.equalTo(backButton)
                    $0.size.equalTo(StaticSize.size(20))
                })
                
                titleLabel.snp.makeConstraints({
                    $0.centerY.equalTo(backButton)
                    $0.left.equalTo(iconView.snp.right).offset(StaticSize.size(9))
                })
            } else {
                titleLabel.snp.makeConstraints({
                    $0.top.equalToSuperview().offset(StaticSize.size(29))
                    $0.left.equalTo(backButton.snp.right).offset(StaticSize.size(7))
                })
            }
        } else {
            if iconImage != nil {
                iconView.snp.makeConstraints({
                    $0.left.equalToSuperview().offset(StaticSize.size(15))
                    $0.centerY.equalTo(backButton)
                    $0.size.equalTo(StaticSize.size(20))
                })
                
                titleLabel.snp.makeConstraints({
                    $0.centerY.equalTo(iconView)
                    $0.left.equalTo(iconView.snp.right).offset(StaticSize.size(9))
                })
            } else {
                titleLabel.snp.makeConstraints({
                    $0.top.equalToSuperview().offset(StaticSize.size(29))
                    $0.left.equalToSuperview().offset(StaticSize.size(15))
                })
            }
        }
        
        subtitleLabel.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(StaticSize.size(12))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        contentView.snp.makeConstraints({
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(StaticSize.size(12))
            $0.left.right.bottom.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
