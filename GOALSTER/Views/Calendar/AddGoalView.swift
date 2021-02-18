//
//  AddGoalView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/16/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class AddGoalView: View, UITextViewDelegate {
    var onFieldChange: (()->())?
    
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.textColor = .deepBlue
        return view
    }()
    
    lazy var inputStack: UIStackView = {
        let view = UIStackView()
        view.addArrangedSubViews(([.timeOfTheDay, .sphere, .goal] as [InputView.ViewType]).map({ InputView(viewType: $0) }))
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(15)
        return view
    }()
    
    lazy var publicSwitchView: SwitchView = {
        let view = SwitchView()
        view.title = "Public goal".localized
        return view
    }()
    
    lazy var observationSwitchView: SwitchView = {
        let view = SwitchView()
        view.title = "Share goal with observer".localized
        return view
    }()
    
    lazy var switchStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [publicSwitchView, observationSwitchView])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(18)
        return view
    }()
    
    lazy var observationInput: InputView = {
        let view = InputView(viewType: .observation)
        return view
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(12), weight: .regular)
        label.textColor = .lightGray
        label.text = "Waiting observer's confirmation".localized
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    
    lazy var observationStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [observationInput, bottomLabel])
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
    
    lazy var innerContainer: UIView = {
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
        let view = UIStackView(arrangedSubviews: [innerContainer])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: StaticSize.size(100), trailing: 0)
        view.axis = .vertical
        view.alignment = .fill
        return view
    }()
    
    required init() {
        super.init(withBackButton: false)
        
        titleLabel.font = .primary(ofSize: StaticSize.size(22), weight: .semiBold)
        title = "Goal addition".localized
        backgroundColor = .white
        
        setUp()
    }
    
    func setTime(time: TimeOfTheDay) {
        (inputStack.arrangedSubviews as? [InputView])?.first(where: {
            $0.viewType == .timeOfTheDay
        })?.buttonInput.setText(text: time.toStr, image: time.icon)
    }
    
    func setSphere(sphere: SelectedSphere, index: Int) {
        (inputStack.arrangedSubviews as? [InputView])?.first(where: {
            $0.viewType == .sphere
        })?.buttonInput.setText(
            text: Sphere.findByName(name: sphere.sphere ?? "").name,
            image: Sphere.findByName(name: sphere.sphere ?? "").icon
        )
    }
    
    func setUp() {
        contentView.addSubViews([dateLabel, container, addButton])
        
        dateLabel.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(StaticSize.size(15))
        })
        
        container.snp.makeConstraints({
            $0.top.equalTo(dateLabel.snp.bottom).offset(StaticSize.size(15))
            $0.left.right.bottom.equalToSuperview()
        })
        
        container.addSubViews([mainScrollView])
        
        mainScrollView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })

        mainScrollView.addSubview(mainStackView)

        mainStackView.snp.makeConstraints({
            $0.edges.width.equalToSuperview()
        })
        
        innerContainer.addSubViews([inputStack, switchStack, observationStack])
        
        inputStack.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(15))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        switchStack.snp.makeConstraints({
            $0.top.equalTo(inputStack.snp.bottom).offset(StaticSize.size(30))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        observationStack.snp.makeConstraints({
            $0.top.equalTo(switchStack.snp.bottom).offset(StaticSize.size(14))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.bottom.equalToSuperview()
        })
        
        addButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(withBackButton: Bool = false, iconImage: UIImage? = nil) {
        fatalError("init(withBackButton:iconImage:) has not been implemented")
    }
}

class SwitchView: UIView {
    var isOn: Bool = false {
        didSet {
            switchButton.isOn = isOn
        }
    }
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var onChange: ((_ isOn: Bool)->())?
    
    lazy var switchButton: UISwitch = {
        let view = UISwitch()
        view.isOn = false
        view.onTintColor = .ultraPink
        view.tintColor = .arcticWhite
        view.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(14), weight: .regular)
        label.textColor = .deepBlue
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    @objc func valueChanged(_ sender: UISwitch) {
        onChange?(sender.isOn)
    }
    
    func setUp() {
        addSubViews([switchButton, titleLabel])
        
        switchButton.snp.makeConstraints({
            $0.left.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        })
        
        titleLabel.snp.makeConstraints({
            $0.left.equalTo(switchButton.snp.right).offset(StaticSize.size(17))
            $0.centerY.right.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
