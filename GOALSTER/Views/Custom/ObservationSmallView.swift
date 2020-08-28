//
//  ObservationSmallView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ObservationSmallView: UIView {
    var observer: String? {
        didSet {
            observerLabel.text = observer
        }
    }
    var isActive: Bool? {
        didSet {
            image.tintColor = UIColor.customActivePurple.withAlphaComponent(isActive ?? false ? 1 : 0.5)
            observerLabel.textColor = UIColor.customTextBlack.withAlphaComponent(isActive ?? false ? 1 : 0.5)
        }
    }
    
    lazy var image: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "observation")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .customActivePurple
        return view
    }()
    
    lazy var observerLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(12), weight: .book)
        label.textColor = .customTextBlack
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([image, observerLabel])
        
        image.snp.makeConstraints({
            $0.left.centerY.equalToSuperview()
            $0.width.equalTo(StaticSize.size(20))
            $0.height.equalTo(StaticSize.size(12))
        })
        
        observerLabel.snp.makeConstraints({
            $0.left.equalTo(image.snp.right).offset(StaticSize.size(4))
            $0.top.right.bottom.equalToSuperview()
        })
    }
}
