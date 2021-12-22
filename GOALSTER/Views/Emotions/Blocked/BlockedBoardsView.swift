//
//  BlockedBoardsView.swift
//  GOALSTER
//
//  Created by Dan on 9/19/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

protocol BlockedBoardsViewDelegate: AnyObject {
    func buttonTapped()
}

class BlockedBoardsView: UIView {
    private let type: BlockedBoardType
    
    weak var delegate: BlockedBoardsViewDelegate?
    
    private lazy var topText: UILabel = {
        let view = UILabel()
        view.text = type.topText
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.textColor = .ultraGray
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = type.image
        return view
    }()
    
    private lazy var bottomText: UILabel = {
        let view = UILabel()
        view.text = type.bottomText
        view.font = .primary(ofSize: StaticSize.size(17), weight: .regular)
        view.textColor = .ultraGray
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private lazy var button: UnlockPremiumButton = {
        let view = UnlockPremiumButton(title: type.buttonText)
        view.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return view
    }()
    
    init(type: BlockedBoardType) {
        self.type = type
        
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubViews([button, bottomText, imageView, topText])
        
        topText.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(22))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        button.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-StaticSize.size(231))
            $0.left.right.equalToSuperview().inset(StaticSize.size(16))
            $0.height.equalTo(StaticSize.size(44))
        })
        
        bottomText.snp.makeConstraints({
            $0.bottom.equalTo(button.snp.top).offset(-StaticSize.size(24))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        imageView.snp.makeConstraints({
            $0.bottom.equalTo(bottomText.snp.top).offset(-StaticSize.size(58))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(StaticSize.size(300))
            $0.height.equalTo(StaticSize.size(200))
        })
    }
    
    @objc func buttonTapped() {
        delegate?.buttonTapped()
    }
}
