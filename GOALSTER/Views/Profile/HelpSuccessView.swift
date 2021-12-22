//
//  HelpSuccessView.swift
//  GOALSTER
//
//  Created by Dan on 2/15/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HelpSuccessView: UIView {
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "sent")
        view.snp.makeConstraints({
            $0.width.equalTo(StaticSize.size(162))
            $0.height.equalTo(StaticSize.size(145))
        })
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .regular)
        view.text = "Sent successfully!".localized
        view.textColor = .ultraGray
        return view
    }()
    
    lazy var bottomButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Back to profile".localized, for: .normal)
        view.snp.makeConstraints({
            $0.height.equalTo(StaticSize.buttonHeight)
        })
        return view
    }()
    
    lazy var topStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView, titleLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = StaticSize.size(12)
        return view
    }()
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [topStack, bottomButton])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(45)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    func setUp() {
        addSubViews([mainStack])
        
        mainStack.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.centerY.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
