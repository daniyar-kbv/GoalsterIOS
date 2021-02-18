//
//  AddEmotionsView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/18/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class AddEmotionsView: View {
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        label.textColor = .deepBlue
        label.adjustsFontSizeToFitWidth = true
        label.text = "Today".localized + " " + "\(Date().format(format: "d MMMM"))"
        return label
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
        let view = UIStackView()
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
    
    required init() {
        super.init(withBackButton: true, iconImage: nil)
        
        title = "Emotion addition".localized
        titleLabel.font = .primary(ofSize: StaticSize.size(22), weight: .semiBold)
        subtitle = "Emotions top text".localized
        
        setUp()
    }
    
    func setUp() {
        contentView.addSubViews([dateLabel, container, addButton])
        
        dateLabel.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        container.snp.makeConstraints({
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
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
        
        addButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
        
        layoutIfNeeded()
    }
    
    func addQuestions(types: [InputView.ViewType], onChange: ((_ object: NSObject)->())?) {
        for type in types {
            let view: InputView = {
                let view = InputView(viewType: type)
                view.onChange = onChange
                return view
            }()
            
            mainStackView.addArrangedSubview(view)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(withBackButton: Bool = false, iconImage: UIImage? = nil) {
        fatalError("init(withBackButton:iconImage:) has not been implemented")
    }
}
