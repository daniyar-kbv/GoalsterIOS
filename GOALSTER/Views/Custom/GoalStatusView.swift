//
//  ObservationSmallView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class GoalStatusView: UIView {
    var goal: Goal? {
        didSet {
            isActive = goal?.isConfirmed
            newCommentImage.isHidden = !(goal?.newComment ?? false)
            publicImage.isHidden = !(goal?.isPublic ?? false)
            observerLabel.text = goal?.observer?.email
            observationImage.isHidden = goal?.observer == nil
            observerLabel.isHidden = goal?.observer == nil
            setUp()
        }
    }
    var isActive: Bool? {
        didSet {
            observationImage.tintColor = UIColor.ultraPink.withAlphaComponent(isActive ?? false ? 1 : 0.5)
            observerLabel.textColor = UIColor.ultraGray.withAlphaComponent(isActive ?? false ? 1 : 0.5)
        }
    }
    
    lazy var publicImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public")
        return view
    }()
    
    lazy var observationImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "observation")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .ultraPink
        return view
    }()
    
    lazy var observerLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(12), weight: .regular)
        label.textColor = .ultraGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var newCommentImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "new_comment")
        return view
    }()
    
    func setUp() {
        for view in subviews {
            view.removeFromSuperview()
        }
        
        if goal?.isPublic ?? false {
            addSubViews([publicImage])
            
            publicImage.snp.makeConstraints({
                $0.left.equalToSuperview().offset(-StaticSize.size(2))
                $0.top.bottom.equalToSuperview()
                $0.size.equalTo(StaticSize.size(20))
            })
        }
        
        addSubViews([newCommentImage, observationImage, observerLabel])
        
        if goal?.newComment ?? false {
            newCommentImage.snp.makeConstraints({
                $0.right.top.bottom.equalToSuperview()
                $0.size.equalTo(StaticSize.size(20))
            })
        }
        
        if goal?.observer != nil {
            observationImage.snp.makeConstraints({
                if goal?.isPublic ?? false {
                    $0.left.equalTo(publicImage.snp.right)
                    $0.centerY.equalToSuperview()
                } else {
                    $0.left.equalToSuperview().offset(-StaticSize.size(2))
                    $0.top.bottom.equalToSuperview()
                }
                $0.size.equalTo(StaticSize.size(20))
            })

            observerLabel.snp.makeConstraints({
                $0.left.equalTo(observationImage.snp.right)
                $0.bottom.equalToSuperview()
            })
        }
    }
}
