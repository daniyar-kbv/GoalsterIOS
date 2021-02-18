//
//  TextViewWithInput.swift
//  GOALSTER
//
//  Created by Daniyar on 8/31/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TextViewWithInput: UITextView, UITextViewDelegate {
    var delegate_: UITextViewDelegate?
    
    lazy var view: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 150))
        view.backgroundColor = .iOSLightGray
        return view
    }()
    
    lazy var textView: InnerTextView = {
        let view = InnerTextView(parent: self)
        return view
    }()
    
    lazy var doneButton: UIButton = {
        let view = UIButton()
        view.setTitle("Done".localized, for: .normal)
        view.setTitleColor(.iOSBlue, for: .normal)
        view.addTarget(self, action: #selector(onDone), for: .touchUpInside)
        return view
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
        
        view.addSubViews([textView, doneButton])
        
        doneButton.snp.makeConstraints({
            let fixedHeight = StaticSize.size(30)
            doneButton.titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedHeight))
            let newSize = doneButton.titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedHeight))
            $0.width.equalTo(newSize?.width ?? StaticSize.size(50))
            $0.right.bottom.equalToSuperview().inset(StaticSize.size(10))
            $0.height.equalTo(fixedHeight)
        })
        
        textView.snp.makeConstraints({
            $0.left.top.bottom.equalToSuperview().inset(StaticSize.size(10))
            $0.right.equalTo(doneButton.snp.left).offset(-StaticSize.size(10))
        })
        
        inputAccessoryView = view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onDone() {
        textView.resignFirstResponder()
        resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let textViewDidBeginEditing = delegate_?.textViewDidBeginEditing {
            textViewDidBeginEditing(textView)
        }
        self.textView.text = textColor == .lightGray ? "" : text
        self.textView.becomeFirstResponder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if let textViewDidEndEditing = delegate_?.textViewDidEndEditing {
            textViewDidEndEditing(textView)
        }
    }
    
    func textViewDidChange(_ textView: UITextView){
        if let textViewDidChange = delegate_?.textViewDidChange {
            textViewDidChange(textView)
        }
    }
    
    class InnerTextView: UITextView, UITextViewDelegate {
        var parent: TextViewWithInput
        var endText: String = ""
        var lastHeight: CGFloat?
        
        required init(parent: TextViewWithInput) {
            self.parent = parent
            
            super.init(frame: .zero, textContainer: .none)
            
            layer.cornerRadius = 10
            layer.borderWidth = 0.5
            layer.borderColor = UIColor.lightGray.cgColor
            
            font = .primary(ofSize: StaticSize.size(15), weight: .regular)
            textColor = .ultraGray
            
            delegate = self
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if let textViewDidBeginEditing = parent.delegate_?.textViewDidBeginEditing {
                textViewDidBeginEditing(textView)
            }
            let fixedWidth = textView.frame.size.width
            textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            parent.view.snp.updateConstraints({
                $0.height.equalTo(newSize.height + StaticSize.size(20))
            })
            if parent.textColor == .lightGray {
                parent.text = ""
            }
        }
        
        func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
            endText = textView.text
            return true
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            parent.text = endText
            if let textViewDidEndEditing = parent.delegate_?.textViewDidEndEditing {
                textViewDidEndEditing(parent)
            }
            parent.selectedTextRange = .none
        }
        
        func textViewDidChange(_ textView: UITextView){
            if let textViewDidChange = parent.delegate_?.textViewDidChange {
                textViewDidChange(textView)
            }
            let fixedWidth = textView.frame.size.width
            textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            parent.view.snp.updateConstraints({
                $0.height.equalTo(newSize.height + StaticSize.size(20))
            })
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return parent.delegate_?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
        }
    }
}

