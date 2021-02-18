//
//  AuthView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class AuthView: View {
    lazy var field: UITextField = {
        let view = UITextField()
        view.placeholder = "example@mail.com"
        view.font = .primary(ofSize: StaticSize.size(32), weight: .bold)
        view.textColor = .ultraGray
        view.keyboardType = .emailAddress
        view.textContentType = .emailAddress
        view.autocapitalizationType = .none
        view.inputAccessoryView = inputButtonView
        return view
    }()
    
    lazy var inputButtonView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: StaticSize.buttonHeight + StaticSize.size(69)))
        return view
    }()
    
    lazy var policyLabel = PolicyLabel(type: .both)
    
    lazy var nextButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Send code".localized, for: .normal)
        view.isActive = false
        return view
    }()
    
    required init() {
        super.init()
        backgroundColor = .white
        
        title = "Sign in".localized
        subtitle = "Enter your email, we will send application login link on it".localized
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(withBackButton: Bool = false, iconImage: UIImage? = nil) {
        fatalError("init(withBackButton:iconImage:) has not been implemented")
    }
    
    func setUp() {
        contentView.addSubViews([field])
        
        field.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(12))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        inputButtonView.addSubViews([policyLabel, nextButton])
        
        policyLabel.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        nextButton.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
            $0.bottom.equalToSuperview().offset(-StaticSize.size(15))
        })
    }
}

class PolicyLabel: UITextView, UITextViewDelegate {
    enum LabelType {
        case agreement
        case privacy
        case both
    }
    
    var type: LabelType
    
    required init(type: LabelType) {
        self.type = type
        
        super.init(frame: .zero, textContainer: .none)
        
        delegate = self
        
        let regularAttributes = [
            NSAttributedString.Key.font: UIFont.primary(ofSize: StaticSize.size(12), weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.middleGray
        ]
        
        let text = NSMutableAttributedString(string: "Policy start".localized, attributes: regularAttributes)
        
        let baseLink = APIPoint.startURL + "/documents/"
        
        switch type {
        case .agreement:
            text.append(NSAttributedString(string: "user agreement".localized))
            let agreementLink = baseLink + "user_agreement_\(ModuleUserDefaults.getLanguage().rawValue).pdf"
            text.addAttributes([
                    NSAttributedString.Key.link: agreementLink,
                    NSAttributedString.Key.font: UIFont.primary(ofSize: StaticSize.size(12), weight: .medium)
                ],
                range: text.string.nsRange(from: text.string.range(of: "user agreement".localized)!)
            )
        case .privacy:
            text.append(NSAttributedString(string: "privacy policy".localized))
            let privacyLink = baseLink + "privacy_policy_\(ModuleUserDefaults.getLanguage().rawValue).pdf"
            text.addAttributes([
                    NSAttributedString.Key.link: privacyLink,
                    NSAttributedString.Key.font: UIFont.primary(ofSize: StaticSize.size(12), weight: .medium)
                ],
                range: text.string.nsRange(from: text.string.range(of: "privacy policy".localized)!)
            )
        case .both:
            text.append(NSAttributedString(string: "user agreement".localized))
            text.append(NSAttributedString(string: "and".localized, attributes: regularAttributes))
            text.append(NSAttributedString(string: "privacy policy".localized))
            let agreementLink = baseLink + "user_agreement_\(ModuleUserDefaults.getLanguage().rawValue).pdf"
            text.addAttributes([
                    NSAttributedString.Key.link: agreementLink,
                    NSAttributedString.Key.font: UIFont.primary(ofSize: StaticSize.size(12), weight: .medium)
                ],
                range: text.string.nsRange(from: text.string.range(of: "user agreement".localized)!)
            )
            let privacyLink = baseLink + "privacy_policy_\(ModuleUserDefaults.getLanguage().rawValue).pdf"
            text.addAttributes([
                    NSAttributedString.Key.link: privacyLink,
                    NSAttributedString.Key.font: UIFont.primary(ofSize: StaticSize.size(12), weight: .medium)
                ],
                range: text.string.nsRange(from: text.string.range(of: "privacy policy".localized)!)
            )
        }
        text.append(NSAttributedString(string: " 24Goals", attributes: regularAttributes))
        
        
        attributedText = text
        textAlignment = .center
        isScrollEnabled = false
        isEditable = false
        isUserInteractionEnabled = true
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        contentInset = .zero
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
