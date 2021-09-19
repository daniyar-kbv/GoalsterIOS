//
//  PremiumButton.swift
//  GOALSTER
//
//  Created by Dan on 9/18/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class UnlockPremiumButton: CustomButton {
    lazy var unlockImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "unlock_premium"))
        view.snp.makeConstraints({
            $0.size.equalTo(StaticSize.size(30))
        })
        return view
    }()
    
    lazy var unlockTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .medium)
        view.textColor = .arcticWhite
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [unlockImage, unlockTitleLabel])
        view.distribution = .equalSpacing
        view.alignment = .center
        view.axis = .horizontal
        view.spacing = StaticSize.size(11)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        
        unlockTitleLabel.text = title
        
        addSubview(stackView)
        stackView.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
