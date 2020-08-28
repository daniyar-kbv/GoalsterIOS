//
//  SpheresDescriptionCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/12/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class SpheresDescriptionSmallView: UIView, UITextViewDelegate {
    var sphere: (key: Sphere, value: String)? {
        didSet {
            icon.image = sphere?.key.icon_active.image
            icon.tintColor = .customActivePurple
            nameLabel.text = sphere?.value
        }
    }
    
    var index: Int? {
        didSet {
            switch index {
            case 0:
                leftView.backgroundColor = .customGoalRed
            case 1:
                leftView.backgroundColor = .customGoalYellow
            case 2:
                leftView.backgroundColor = .customGoalGreen
            default:
                break
            }
        }
    }
    
    var onChange: ((_ textView: UITextView)->())?
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(18), weight: .book)
        label.textColor = .customTextDarkPurple
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var topTextLabel: UILabel = {
        let view = UILabel()
        view.font = .gotham(ofSize: StaticSize.size(12), weight: .light)
        view.textColor = .customTextDarkPurple
        view.text = "Text about more detailed shpere's goal description".localized
        return view
    }()
    
    lazy var textFieldView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy var leftView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var textView: CustomTextView = {
        let view = CustomTextView()
        view.font = .gotham(ofSize: StaticSize.size(15), weight: .book)
        view.textColor = .lightGray
        view.text = "Enter description here".localized
        view.isScrollEnabled = false
        view.delegate_ = self
        view.constraints_ = {
//            let newSize = self.sizeThatFits(CGSize(width: ScreenSize.SCREEN_WIDTH - StaticSize.size(94), height: CGFloat.greatestFiniteMagnitude))
            $0.top.equalToSuperview().offset(StaticSize.size(5))
            $0.left.equalTo(self.leftView.snp.right)
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.bottom.equalToSuperview().offset(-StaticSize.size(5))
//            $0.height.equalTo(newSize.height)
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([icon, nameLabel, topTextLabel, textFieldView])
        
        icon.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.size.equalTo(StaticSize.size(30))
        })
        
        nameLabel.snp.makeConstraints({
            $0.left.equalTo(icon.snp.right).offset(StaticSize.size(15))
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.centerY.equalTo(icon)
        })
        
        topTextLabel.snp.makeConstraints({
            $0.top.equalTo(nameLabel.snp.bottom).offset(StaticSize.size(4))
            $0.left.equalTo(nameLabel)
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
        })
        
        textFieldView.snp.makeConstraints({
            $0.left.equalTo(topTextLabel)
            $0.top.equalTo(topTextLabel.snp.bottom).offset(StaticSize.size(14))
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.bottom.equalToSuperview().offset(-StaticSize.size(15))
        })
        
        textFieldView.addSubViews([leftView, textView])
        
        leftView.snp.makeConstraints({
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(StaticSize.size(4))
        })
        
        textView.snp.makeConstraints({
//            let newSize = textView.sizeThatFits(CGSize(width: ScreenSize.SCREEN_WIDTH - StaticSize.size(94), height: CGFloat.greatestFiniteMagnitude))
            $0.top.equalToSuperview().offset(StaticSize.size(5))
            $0.left.equalTo(leftView.snp.right)
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.bottom.equalToSuperview().offset(-StaticSize.size(5))
//            $0.height.equalTo(newSize.height)
        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .customTextBlack
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if let onChange = onChange {
            onChange(textView)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let onChange = onChange {
            onChange(textView)
        }
//        let fixedWidth = textView.frame.size.width
//        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        textView.snp.updateConstraints({
//            $0.height.equalTo(newSize.height)
//        })
    }
}
