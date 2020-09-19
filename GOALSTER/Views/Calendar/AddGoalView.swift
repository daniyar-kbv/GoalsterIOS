//
//  AddGoalView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/16/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class AddGoalView: UIView, UITextViewDelegate {
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
        view.text = "Goal addition".localized 
        view.font = .gotham(ofSize: StaticSize.size(21), weight: .medium)
        view.textColor = .customTextDarkPurple
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = .gotham(ofSize: StaticSize.size(12), weight: .bold)
        view.textColor = .customTextDarkPurple
        return view
    }()
    
    lazy var firstTopLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(12), weight: .book)
        label.textColor = .customTextDarkPurple
        label.adjustsFontSizeToFitWidth = true
        label.text = "Choose time of day".localized
        return label
    }()
    
    lazy var firstBottom: UIButton = {
        let view = UIButton()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = StaticSize.size(5)
        view.setTitle("Choose time of day".localized, for: .normal)
        view.titleLabel?.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.setTitleColor(.lightGray, for: .normal)
        return view
    }()
    
    lazy var firstArrow: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrowRight")
        return view
    }()
    
    lazy var firstStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [firstTopLabel, firstBottom])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(6)
        return view
    }()
    
    lazy var secondTopLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(12), weight: .book)
        label.textColor = .customTextDarkPurple
        label.adjustsFontSizeToFitWidth = true
        label.text = "Choose sphere which goal applies to".localized
        return label
    }()
    
    lazy var secondBottom: UIButton = {
        let view = UIButton()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = StaticSize.size(5)
        view.setTitle("Choose sphere".localized, for: .normal)
        view.titleLabel?.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.setTitleColor(.lightGray, for: .normal)
        return view
    }()
    
    lazy var secondArrow: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrowRight")
        return view
    }()
    
    lazy var secondStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [secondTopLabel, secondBottom])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(6)
        return view
    }()
    
    lazy var thirdTopLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(12), weight: .book)
        label.textColor = .customTextDarkPurple
        label.adjustsFontSizeToFitWidth = true
        label.text = "Enter your goal".localized
        return label
    }()
    
    lazy var thirdBottom: TextViewWithInput = {
        let view = TextViewWithInput()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = StaticSize.size(5)
        view.text = "Enter goal".localized
        view.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.textColor = .lightGray
        view.isScrollEnabled = false
        view.delegate_ = self
        view.textContainerInset = UIEdgeInsets(top: StaticSize.size(11), left: StaticSize.size(StaticSize.size(5)), bottom: StaticSize.size(9), right: StaticSize.size(11))
        return view
    }()
    
    lazy var thirdStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [thirdTopLabel, thirdBottom])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(6)
        return view
    }()
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [firstStack, secondStack, thirdStack])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(15)
        return view
    }()
    
    lazy var switchButton: UISwitch = {
        let view = UISwitch()
        view.isOn = false
        return view
    }()
    
    lazy var shareText: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(14), weight: .book)
        label.textColor = .customTextDarkPurple
        label.adjustsFontSizeToFitWidth = true
        label.text = "Share goal with observer".localized
        return label
    }()
    
    lazy var fourthTopLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(12), weight: .book)
        label.textColor = .customTextDarkPurple
        label.adjustsFontSizeToFitWidth = true
        label.text = "Choose your observer".localized
        return label
    }()
    
    lazy var fourthBottom: UIButton = {
        let view = UIButton()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = StaticSize.size(5)
        view.setTitle("Choose observer".localized, for: .normal)
        view.titleLabel?.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.setTitleColor(.lightGray, for: .normal)
        return view
    }()
    
    lazy var fourthArrow: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrowRight")
        return view
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(12), weight: .book)
        label.textColor = .lightGray
        label.text = "Waiting observer's confirmation".localized
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    
    lazy var fourthStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [fourthTopLabel, fourthBottom, bottomLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(6)
        view.isHidden = true
        return view
    }()
    
    lazy var addButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Add".localized, for: .normal)
        view.isActive = false
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
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
        let view = UIStackView(arrangedSubviews: [mainStack, bottomView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: StaticSize.size(10), leading: StaticSize.size(15), bottom: StaticSize.size(100), trailing: StaticSize.size(15))
        view.axis = .vertical
        view.alignment = .fill
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
    
    func setUp() {
        addSubViews([topBrush, backButton, titleLabel, dateLabel, container, addButton])
        
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
        
        dateLabel.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(StaticSize.size(16))
            $0.left.equalToSuperview().offset(StaticSize.size(15))
        })
        
        container.snp.makeConstraints({
            $0.top.equalTo(dateLabel.snp.bottom).offset(StaticSize.size(14))
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
        
        firstBottom.snp.makeConstraints({
            $0.height.equalTo(StaticSize.size(36))
        })
        
        firstBottom.titleLabel?.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(11))
            $0.centerY.equalToSuperview()
        })
        
        secondBottom.snp.makeConstraints({
            $0.height.equalTo(StaticSize.size(36))
        })
        
        secondBottom.titleLabel?.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(11))
        })
        
        thirdBottom.snp.makeConstraints({
            $0.height.equalTo(StaticSize.size(36)).priority(.low)
        })
        
        firstBottom.addSubViews([firstArrow])
        firstArrow.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(17))
            $0.centerY.equalToSuperview()
            $0.width.equalTo(StaticSize.size(6))
            $0.height.equalTo(StaticSize.size(10.5))
        })
        
        secondBottom.addSubViews([secondArrow])
        secondArrow.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(17))
            $0.centerY.equalToSuperview()
            $0.width.equalTo(StaticSize.size(6))
            $0.height.equalTo(StaticSize.size(10.5))
        })
        
        bottomView.addSubViews([switchButton, shareText, fourthStack])
        
        switchButton.snp.makeConstraints({
            $0.left.equalToSuperview()
            $0.top.equalToSuperview().offset(StaticSize.size(34))
            $0.width.equalTo(StaticSize.size(52))
            $0.height.equalTo(StaticSize.size(32))
        })
        
        shareText.snp.makeConstraints({
            $0.left.equalTo(switchButton.snp.right).offset(StaticSize.size(18))
            $0.right.equalToSuperview()
            $0.centerY.equalTo(switchButton)
        })
        
        fourthStack.snp.makeConstraints({
            $0.top.equalTo(switchButton.snp.bottom).offset(StaticSize.size(16))
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        
        fourthBottom.snp.makeConstraints({
            $0.height.equalTo(StaticSize.size(36))
        })
        
        fourthBottom.titleLabel?.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(11))
            $0.centerY.equalToSuperview()
        })
        
        fourthBottom.addSubViews([fourthArrow])
        fourthArrow.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(17))
            $0.centerY.equalToSuperview()
            $0.width.equalTo(StaticSize.size(6))
            $0.height.equalTo(StaticSize.size(10.5))
        })
        
        addButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .customTextBlack
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter goal".localized
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
    
    func setTime(time: TimeOfTheDay) {
        for subView in firstBottom.subviews {
            if ![firstArrow].contains(subView) {
                subView.removeFromSuperview()
            }
        }
        
        let icon: UIImageView = {
            let view = UIImageView()
            view.image = time.icon
            return view
        }()
        
        let title: UILabel = {
            let label = UILabel()
            label.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
            label.textColor = .customTextBlack
            label.adjustsFontSizeToFitWidth = true
            label.text = time.toStr
            return label
        }()
        
        firstBottom.addSubViews([icon, title])
        icon.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(9))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(StaticSize.size(20))
        })
        
        title.snp.makeConstraints({
            $0.left.equalTo(icon.snp.right).offset(StaticSize.size(5)).priority(.high)
            $0.centerY.equalToSuperview()
        })
    }
    
    func setSphere(sphere: SelectedSphere, index: Int) {
        for subView in secondBottom.subviews {
            if ![secondArrow].contains(subView) {
                subView.removeFromSuperview()
            }
        }
        
        let icon: UIImageView = {
            let view = UIImageView()
            view.image = Sphere.findByName(name: sphere.sphere ?? "").icon_active.image
            view.tintColor = .customActivePurple
            return view
        }()
        
        let dot: UIImageView = {
            let view = UIImageView()
            view.image = UIImage(named: "dot")?.withRenderingMode(.alwaysTemplate)
            switch index {
            case 0:
                view.tintColor = .customGoalRed
            case 1:
                view.tintColor = .customGoalYellow
            case 2:
                view.tintColor = .customGoalGreen
            default:
                break
            }
            return view
        }()
        
        let title: UILabel = {
            let label = UILabel()
            label.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
            label.textColor = .customTextBlack
            label.adjustsFontSizeToFitWidth = true
            label.text = sphere.sphere
            return label
        }()
        
        secondBottom.addSubViews([icon, title, dot])
        
        icon.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(9))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(StaticSize.size(25))
        })
        
        title.snp.makeConstraints({
            $0.left.equalTo(icon.snp.right).offset(StaticSize.size(5)).priority(.high)
            $0.centerY.equalToSuperview()
        })
        
        dot.snp.makeConstraints({
            $0.left.equalTo(title.snp.right).offset(StaticSize.size(5))
            $0.size.equalTo(StaticSize.size(8))
            $0.centerY.equalToSuperview()
        })
    }
}
