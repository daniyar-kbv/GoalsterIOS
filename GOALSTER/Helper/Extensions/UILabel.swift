//
//  UILabel.swift
//  Samokat
//
//  Created by Daniyar on 8/4/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

    extension UILabel {
        func setLineHeight(lineHeight: CGFloat) {
            var attributeStringInitial: NSMutableAttributedString?
            var textInitial: String?
            
            if let text_ = self.text {
                attributeStringInitial = NSMutableAttributedString(string: text_)
                textInitial = text_
            } else if let text_ = self.attributedText {
                attributeStringInitial = NSMutableAttributedString(attributedString: text_)
                textInitial = text_.string
            }
            
            guard let attributeString = attributeStringInitial,
                  let text = textInitial
            else { return }
                
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
        }
        
        func setLineHeight(lineHeight: CGFloat, disposeBag: DisposeBag) {
            rx.observe(String.self, "text")
                .subscribe(onNext: { [weak self] text in
                    self?.setLineHeight(lineHeight: 10)
                })
                .disposed(by: disposeBag)
        }
    }

enum StatusNames: String {
    case created = "CREATED"
    case canceled = "CANCELED"
    case completed = "COMPLETED"
}
