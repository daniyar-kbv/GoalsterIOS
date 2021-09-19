//
//  FeedPremiumCell.swift
//  GOALSTER
//
//  Created by Dan on 9/18/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

protocol FeedPremiumCellDelegate: AnyObject {
    func buttonTapped()
}

class FeedPremiumCell: UITableViewCell {
    static let reuseIdentifier = "FeedPremiumCell"
    
    weak var delegate: FeedPremiumCellDelegate?
    
    lazy var premiumButton: UnlockPremiumButton = {
        let view = UnlockPremiumButton(title: "Premium.Button.unlock".localized)
        view.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        contentView.addSubview(premiumButton)
        premiumButton.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(StaticSize.size(44))
            $0.bottom.equalToSuperview().offset(-StaticSize.size(32))
        })
    }
    
    @objc func buttonTapped() {
        delegate?.buttonTapped()
    }
}
