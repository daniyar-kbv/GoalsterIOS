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
    
    lazy var topBrush: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    lazy var backButton: BackButton = {
        let view = BackButton()
        return view
    }()
    
    lazy var titleLabel: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.text = "Help".localized
        view.font = .gotham(ofSize: StaticSize.size(21), weight: .medium)
        view.textColor = .customTextDarkPurple
        return view
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInsetAdjustmentBehavior = .never
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [topLabel, textView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: StaticSize.size(30), leading: StaticSize.size(15), bottom: StaticSize.size(100), trailing: StaticSize.size(15))
        view.axis = .vertical
        view.alignment = .fill
        return view
    }()
    
    lazy var topLabel: CustomLabelWithoutPadding = {
        let label = CustomLabelWithoutPadding()
        label.font = .gotham(ofSize: StaticSize.size(12), weight: .book)
        label.textColor = .customTextDarkPurple
        label.text = "Help top text".localized
        return label
    }()
    
    lazy var textView: CustomTextView = {
        let view = CustomTextView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = StaticSize.size(5)
        view.text = "Enter text".localized
        view.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.textColor = .lightGray
        view.isScrollEnabled = false
        view.delegate_ = self
        view.constraints_ = {
            $0.top.equalTo(self.topLabel.snp.bottom).offset(-StaticSize.size(10))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        }
        view.textContainerInset = UIEdgeInsets(top: StaticSize.size(11), left: StaticSize.size(StaticSize.size(5)), bottom: StaticSize.size(9), right: StaticSize.size(11))
        return view
    }()
    
    lazy var addButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Send".localized, for: .normal)
        view.isActive = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var initialMaxY: CGFloat?
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .customTextBlack
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter text".localized
            textView.textColor = .lightGray
        }
        if let onFieldChange = onFieldChange {
            onFieldChange()
        }
    }
    
    func textViewDidChange(_ textView: UITextView){
        if let onFieldChange = onFieldChange {
            onFieldChange()
        }
    }
    
    func setUp() {
        addSubViews([topBrush, backButton, titleLabel, container, addButton])
        
        container.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(StaticSize.size(7))
            $0.left.right.bottom.equalToSuperview()
        })
        
        container.addSubViews([mainScrollView])
        
        mainScrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true;
        mainScrollView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true;
        mainScrollView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true;
        mainScrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true;

        mainScrollView.addSubview(mainStackView)

        mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true;
        mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor).isActive = true;
        mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true;
        mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        
        topBrush.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(5)
            $0.width.equalTo(45)
            $0.centerX.equalToSuperview()
        })
        
        backButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(25))
            $0.left.equalToSuperview().offset(StaticSize.size(10))
            $0.size.equalTo(StaticSize.size(30))
        })
        
        titleLabel.snp.makeConstraints({
            $0.left.equalTo(backButton.snp.right).offset(StaticSize.size(15))
            $0.top.equalToSuperview().offset(StaticSize.size(30))
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
        })
        
//        topLabel.snp.makeConstraints({
//            $0.top.equalTo(titleLabel.snp.bottom).offset(StaticSize.size(37))
//            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
//        })
//
//        textView.snp.makeConstraints({
//            $0.top.equalTo(topLabel.snp.bottom).offset(-StaticSize.size(10))
//            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
//        })
        
        addButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
}
