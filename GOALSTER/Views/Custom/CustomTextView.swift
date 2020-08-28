//
//  TextViewWithInput.swift
//  GOALSTER
//
//  Created by Daniyar on 8/27/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CustomTextView: UITextView, UITextViewDelegate {
    var delegate_: UITextViewDelegate?
    var lastHeight: CGFloat?
    var constraints_: ((_ make: ConstraintMaker) -> Void)?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let textViewDidBeginEditing = delegate_?.textViewDidBeginEditing {
            textViewDidBeginEditing(textView)
        }
        configTextView(textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if let textViewDidEndEditing = delegate_?.textViewDidEndEditing {
            textViewDidEndEditing(textView)
        }
        less(textView)
    }
    
    func textViewDidChange(_ textView: UITextView){
        if let textViewDidChange = delegate_?.textViewDidChange {
            textViewDidChange(textView)
        }
        configTextView(textView)
    }
    
    func configTextView(_ textView: UITextView) {
        let globalPoint = textView.superview?.convert(textView.frame, to: nil)
        if textView.contentSize.height >= ((ScreenSize.SCREEN_HEIGHT - (AppShared.sharedInstance.openedKeyboardSize?.height ?? 0)) - (globalPoint?.minY ?? 0)) {
            more(textView)
        } else {
            less(textView)
        }
    }
    
    func more(_ textView: UITextView) {
        textView.isScrollEnabled = true
        if let height = lastHeight {
            textView.snp.makeConstraints({
                $0.height.equalTo(height)
            })
        }
    }
    
    func less(_ textView: UITextView) {
        lastHeight = textView.frame.size.height
        textView.frame.size.height = textView.contentSize.height
        textView.isScrollEnabled = false
        if let constraints = constraints_ {
            textView.snp.remakeConstraints(constraints)
        }
        textView.text.append(" ")
        textView.text.popLast()
        layoutSubviews()
    }
}
