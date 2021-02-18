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
    var initialHeight: CGFloat = 0
    
    var sphere: (key: Sphere, value: String)
    var fromProfile: Bool
    
    var index: Int? {
        didSet {
            let total = ModuleUserDefaults.getTotalGoals()
            switch index {
            case 0:
                leftView.backgroundColor = .greatRed
                goalsNumberLabel.text = total?.first?.toGoalsNumber()
            case 1:
                leftView.backgroundColor = .goodYellow
                goalsNumberLabel.text = total?.second?.toGoalsNumber()
            case 2:
                leftView.backgroundColor = .calmGreen
                goalsNumberLabel.text = total?.third?.toGoalsNumber()
            default:
                break
            }
        }
    }
    
    lazy var goalsNumberLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(44), weight: .black)
        view.textColor = .deepBlue
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(18), weight: .medium)
        label.textColor = .deepBlue
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var editButton: UIButton = {
        let view = UIButton()
        view.setAttributedTitle(
            NSAttributedString(
                string: "Edit".localized,
                attributes: [
                    NSAttributedString.Key.font: UIFont.primary(ofSize: StaticSize.size(13), weight: .light),
                    NSAttributedString.Key.foregroundColor: UIColor.deepBlue,
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                    NSAttributedString.Key.underlineColor: UIColor.deepBlue
                ]
            ),
            for: .normal
        )
        view.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
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
    
    lazy var textView: PrimaryTextView = {
        let view = PrimaryTextView(placeholder: "Enter description here".localized, title: sphere.key.name, iconImage: sphere.key.icon)
        view.font = .primary(ofSize: StaticSize.size(13), weight: .regular)
        view.isUserInteractionEnabled = !fromProfile
        view.isScrollEnabled = false
        return view
    }()
    
    required init(sphere: (key: Sphere, value: String), fromProfile: Bool = false) {
        self.sphere = sphere
        self.fromProfile = fromProfile
        
        super.init(frame: .zero)
        
        icon.image = sphere.key.icon
        nameLabel.text = sphere.value
        
        setUp()
    }
    
    @objc func editTapped() {
        _ = textView.textViewShouldBeginEditing(textView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([icon, nameLabel, textFieldView])
        
        icon.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.size.equalTo(StaticSize.size(20))
        })
        
        nameLabel.snp.makeConstraints({
            $0.left.equalTo(icon.snp.right).offset(StaticSize.size(8))
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.centerY.equalTo(icon)
        })
        
        textFieldView.snp.makeConstraints({
            $0.left.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(StaticSize.size(16))
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.bottom.equalToSuperview()
        })
        
        textFieldView.addSubViews([leftView, textView])
        
        leftView.snp.makeConstraints({
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(StaticSize.size(4))
        })
        
        textView.snp.makeConstraints({
            $0.top.left.right.equalToSuperview().inset(StaticSize.size(10))
            $0.bottom.equalToSuperview().offset(-StaticSize.size(5))
        })
        
        if fromProfile {
            insertSubview(goalsNumberLabel, at: 0)
            addSubview(editButton)
            
            goalsNumberLabel.snp.makeConstraints({
                $0.top.equalToSuperview()
                $0.left.equalToSuperview().offset(StaticSize.size(44))
                $0.right.equalToSuperview().inset(StaticSize.size(15))
            })

            icon.snp.remakeConstraints({
                $0.top.equalTo(goalsNumberLabel.snp.bottom).offset(StaticSize.size(12))
                $0.left.equalToSuperview().offset(StaticSize.size(15))
                $0.size.equalTo(StaticSize.size(20))
            })

            editButton.snp.makeConstraints({
                $0.right.equalToSuperview().offset(-StaticSize.size(15))
                $0.centerY.equalTo(icon)
            })

            nameLabel.snp.remakeConstraints({
                $0.right.equalTo(editButton.snp.left).offset(StaticSize.size(10))
                $0.left.equalTo(icon.snp.right).offset(StaticSize.size(8))
                $0.centerY.equalTo(icon)
            })
        }
    }
}
