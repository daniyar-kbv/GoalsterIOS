//
//  AddVisualizationsView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/19/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class AddVisualizationsView: UIView, UITextViewDelegate {
    var onFieldChange: (()->())?
    var globalMaxY: CGFloat?
    
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
        view.text = "Visualization addition".localized
        view.font = .gotham(ofSize: StaticSize.size(21), weight: .medium)
        view.textColor = .customTextDarkPurple
        return view
    }()
    
    lazy var firstTopLabel: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(12), weight: .book)
        label.textColor = .customTextDarkPurple
        label.adjustsFontSizeToFitWidth = true
        label.text = "Choose sphere".localized
        return label
    }()
    
    lazy var firstBottom: UIButton = {
        let view = UIButton()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = StaticSize.size(5)
        view.setTitle("Choose sphere".localized, for: .normal)
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
        label.text = "Choose image".localized
        return label
    }()
    
    lazy var secondBottom: UIButton = {
        let view = UIButton()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = StaticSize.size(5)
        view.setTitle("Choose image".localized, for: .normal)
        view.titleLabel?.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.setTitleColor(.lightGray, for: .normal)
        return view
    }()
    
    lazy var secondOutterContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var secondContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = StaticSize.size(17)
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.isHidden = true
        return view
    }()
    
    lazy var secondArrow: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrowRight")
        return view
    }()
    
    lazy var secondStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [secondTopLabel, secondBottom, secondOutterContainer])
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
        label.text = "Add annotation (optional)".localized
        return label
    }()
    
    lazy var thirdBottom: TextViewWithInput = {
        let view = TextViewWithInput()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = StaticSize.size(5)
        view.text = "Add annotation".localized
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
        let view = UIStackView(arrangedSubviews: [firstStack, secondStack, thirdStack])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: StaticSize.size(100), trailing: 0)
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = StaticSize.size(18)
        return view
    }()
    
    lazy var addButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Add".localized, for: .normal)
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
    
    func setUp() {
        addSubViews([topBrush, backButton, titleLabel, container, addButton])
        
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
            $0.left.equalTo(backButton.snp.right).offset(StaticSize.size(5))
            $0.top.equalToSuperview().offset(StaticSize.size(30))
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
        })
        
        container.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.left.right.bottom.equalToSuperview().inset(StaticSize.size(15))
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
        
        secondOutterContainer.addSubViews([secondContainer])
        
        secondContainer.snp.makeConstraints({
            $0.left.top.bottom.equalToSuperview()
        })
        
        secondContainer.addSubViews([imageView])
        
        imageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
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
        
        addButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
        
        layoutIfNeeded()
    }
    
    func setSphere(sphere: SelectedSphere, index: Int) {
        for subView in firstBottom.subviews {
            if ![firstArrow].contains(subView) {
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
        
        firstBottom.addSubViews([icon, title, dot])
        
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .customTextBlack
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add annotation".localized
            textView.textColor = .lightGray
        }
        if let onChange = onFieldChange {
            onChange()
        }
    }
    
    func textViewDidChange(_ textView: UITextView){
        if let onFieldChange = onFieldChange {
            onFieldChange()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 32
    }
}
