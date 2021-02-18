//
//  PrimaryTextField.swift
//  GOALSTER
//
//  Created by Dan on 1/28/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TextFieldView: View {
    
    lazy var textView: TextView = {
        let view = TextView(placeholder: "", withBorders: true)
        view.inputAccessoryView = inputButtonView
        view.textColor = .ultraGray
        return view
    }()
    
    lazy var inputButtonView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: StaticSize.buttonHeight + StaticSize.size(30)))
        return view
    }()
    
    lazy var nextButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Save".localized, for: .normal)
        return view
    }()
    
    required init(withBackButton: Bool = false, iconImage: UIImage? = nil) {
        super.init(withBackButton: true, iconImage: iconImage)
        
        backgroundColor = .white
        iconView.tintColor = .ultraPink
        titleLabel.font = .primary(ofSize: StaticSize.size(18), weight: .medium)
        
        setUp()
    }
    
    func setUp() {
        contentView.addSubViews([textView])
        
        textView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(4))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.bottom.equalToSuperview().offset(-(StaticSize.buttonHeight + StaticSize.size(30)))
        })
        
        inputButtonView.addSubview(nextButton)
        nextButton.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(StaticSize.size(15))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(withBackButton: Bool = false) {
        fatalError("init(withBackButton:) has not been implemented")
    }
}

class TextView: UITextView, UITextViewDelegate {
    var placeholder: String
    var isEmpty = true {
        didSet {
            textColor = isEmpty ? .strongGray : .ultraGray
            if isEmpty {
                text = placeholder
            }
        }
    }
    var onBegin: (()->())?
    var onEnd: (()->())?
    var onChange: ((_ textView: UITextView)->())?
    
    required init(placeholder: String, withBorders: Bool = false) {
        self.placeholder = placeholder
        
        super.init(frame: .zero, textContainer: .none)
        
        delegate = self
        
        textColor = .strongGray
        font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        text = placeholder
        
        if withBorders {
            textContainerInset = UIEdgeInsets(top: StaticSize.size(11), left: StaticSize.size(StaticSize.size(5)), bottom: StaticSize.size(8), right: StaticSize.size(11))
            layer.borderColor = UIColor.borderGray.cgColor
            layer.borderWidth = 0.5
            layer.cornerRadius = StaticSize.size(5)
        } else {
            textContainerInset = .zero
            textContainer.lineFragmentPadding = 0
            contentInset = .zero
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        isEmpty = textView.text == ""
        onChange?(textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        onBegin?()
        onChange?(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        onEnd?()
        onChange?(textView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PrimaryTextView: TextView, Input {
    var title: String
    var iconImage: UIImage?
    var change: ((_ object: NSObject)->())? {
        didSet {
            onChange = { textView in
                self.change?(textView)
            }
        }
    }
    
    lazy var rightArrow: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrowRight")
        view.isUserInteractionEnabled = false
        return view
    }()
    
    required init(placeholder: String, title: String, iconImage: UIImage? = nil, withBorders: Bool = false, withArrow: Bool = false) {
        self.title = title
        self.iconImage = iconImage
        
        super.init(placeholder: placeholder, withBorders: withBorders)
        
        delegate = self
        
        if withArrow{
            addSubViews([rightArrow])
            
            rightArrow.snp.makeConstraints({
                $0.right.equalToSuperview().offset(-StaticSize.size(15))
                $0.centerY.equalToSuperview()
                $0.width.equalTo(StaticSize.size(6))
                $0.height.equalTo(StaticSize.size(10.5))
            })
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(placeholder: String) {
        fatalError("init(placeholder:) has not been implemented")
    }
    
    required init(placeholder: String, withBorders: Bool = false) {
        fatalError("init(placeholder:withBorders:) has not been implemented")
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let vc = viewContainingController(), !vc.children.contains(where: { $0 is TextFieldViewController }) {
            let vc = TextFieldViewController(textView: self, iconImage: iconImage, parentVc: vc)
            vc.mainView.title = title
            vc.onChange = onChange
            viewContainingController()?.openTop(vc: vc)
        }
        return false
    }
}
