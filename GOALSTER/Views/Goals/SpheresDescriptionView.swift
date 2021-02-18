//
//  SpheresDescriptionView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/12/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class SpheresDescriptionView: View {
    var spheres: [(key: Sphere, value: String)]
    var fromProfile: Bool
    
    lazy var nextButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Save".localized, for: .normal)
        view.isActive = false
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
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: StaticSize.size(100), trailing: 0)
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = StaticSize.size(30)
        for (index, sphere) in spheres.enumerated() {
            let sphereView = SpheresDescriptionSmallView(sphere: sphere, fromProfile: fromProfile)
            sphereView.index = index
            view.addArrangedSubview(sphereView)
        }
        return view
    }()
    
    required init(spheres: [(key: Sphere, value: String)], fromProfile: Bool = false) {
        self.spheres = spheres
        self.fromProfile = fromProfile
        
        super.init(withBackButton: !fromProfile)
        backgroundColor = .white
        
        titleLabel.font = .primary(ofSize: StaticSize.size(22), weight: .semiBold)
        
        switch fromProfile {
        case false:
            title = "Text specifying goals for each sphere".localized
        case true:
            title = "Goals done in a month".localized
            titleLabel.textAlignment = .center
        }
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(withBackButton: Bool = false) {
        fatalError("init(withBackButton:) has not been implemented")
    }
    
    required init(withBackButton: Bool = false, iconImage: UIImage? = nil) {
        fatalError("init(withBackButton:iconImage:) has not been implemented")
    }
    
    func setUp() {
        contentView.addSubViews([container, nextButton])
        
        container.snp.makeConstraints({
            $0.top.equalToSuperview()
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
        
        nextButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
}
