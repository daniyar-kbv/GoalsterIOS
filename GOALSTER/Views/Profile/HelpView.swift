//
//  HelpView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class HelpView: UIView, UITextViewDelegate {
    var onFieldChange: (()->())?
    
    lazy var fakeTextView: PrimaryTextView = {
        let view = PrimaryTextView(placeholder: "", title: "")
        return view
    }()
    
    lazy var topTextLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.textColor = .strongGray
        view.text = "Help top text".localized
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    func setUp() {
        addSubViews([topTextLabel])
        
        topTextLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(25))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
