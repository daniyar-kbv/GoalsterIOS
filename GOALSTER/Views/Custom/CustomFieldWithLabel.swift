//
//  CustomFieldWithLabel.swift
//  GOALSTER
//
//  Created by Daniyar on 8/18/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class CustomFieldWithLabel: UIView, UITextViewDelegate {
    var placeholder: String
    var onChange: (()->())?
    var initialHeight: CGFloat = 0
    
    lazy var label: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(16), weight: .bold)
        view.textColor = .deepBlue
        return view
    }()
    
    lazy var textView: TextViewWithInput = {
        let view = TextViewWithInput()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = StaticSize.size(5)
        view.text = placeholder
        view.font = .primary(ofSize: StaticSize.size(16), weight: .regular)
        view.textColor = .lightGray
        view.isScrollEnabled = false
        view.delegate_ = self
        view.textContainerInset = UIEdgeInsets(top: StaticSize.size(11), left: StaticSize.size(StaticSize.size(5)), bottom: StaticSize.size(9), right: StaticSize.size(11))
        return view
    }()
    
    
    required init(placeholder: String) {
        self.placeholder = placeholder
        
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([label, textView])
        
        label.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
        })
        
        textView.snp.makeConstraints({
            $0.top.equalTo(label.snp.bottom).offset(StaticSize.size(6))
            $0.left.right.bottom.equalToSuperview()
        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .ultraGray
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if let onChange = onChange {
            onChange()
        }
        if textView.text == "" {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let onChange = onChange {
            onChange()
        }
    }
}
