//
//  SpheresListCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/12/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SpheresListCell: UITableViewCell, UITextViewDelegate {
    lazy var disposeBag = DisposeBag()
    lazy var placeholder = ""
    
    static let reuseIdentifier = "SpheresListCell"
    var isActive: Bool = false {
        didSet {
            if isActive{
                icon.image = sphere?.icon_active.image
                icon.tintColor = .customActivePurple
            } else {
                icon.image = sphere?.icon_inactive.image
            }
            radio.image = isActive ? UIImage(named: "radio_active") : UIImage(named: "radio_inactive")
        }
    }
    var sphere: Sphere? {
        didSet {
            icon.image = sphere?.icon_inactive.image
            if sphere == .addOwnOption{
                nameField.text = sphere?.name
                placeholder = sphere?.name ?? ""
                nameField.isUserInteractionEnabled = true
            } else {
                nameField.text = sphere?.name
                nameField.isUserInteractionEnabled = false
            }
        }
    }
    var onChange: ((_ text: String?)->())? 
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var nameField: TextViewWithInput = {
        let label = TextViewWithInput()
        label.font = .gotham(ofSize: StaticSize.size(18), weight: .light)
        label.textColor = .customTextDarkPurple
        label.isScrollEnabled = false
        label.delegate_ = self
        return label
    }()
    
    lazy var radio: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "radio_inactive")
        return view
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)
        
        selectionStyle = .none
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([icon, radio, nameField, bottomLine])
        
        icon.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(StaticSize.size(30))
        })
        
        radio.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(StaticSize.size(24))
        })
        
        nameField.snp.makeConstraints({
            $0.left.equalTo(icon.snp.right).offset(StaticSize.size(15))
            $0.centerY.equalToSuperview()
            $0.right.equalTo(radio.snp.left).offset(-StaticSize.size(15))
        })
        
        bottomLine.snp.makeConstraints({
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.left.equalTo(nameField.snp.left)
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameField.text = ""
        nameField.textColor = .customTextBlack
        isActive = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .customTextBlack
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let onChange = onChange {
            onChange(textView.text)
        }
    }
}
