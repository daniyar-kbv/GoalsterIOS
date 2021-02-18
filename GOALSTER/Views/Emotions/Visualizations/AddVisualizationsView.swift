//
//  AddVisualizationsView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/19/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class AddVisualizationsView: View, UITextViewDelegate {
    lazy var viewTypes: [InputView.ViewType] = [.sphere, .visualization, .annotation]
    
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
        let view = UIStackView(arrangedSubviews: viewTypes.map({ InputView(viewType: $0) }))
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: StaticSize.size(100), trailing: 0)
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(15)
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
        
        title = "Visualization addition".localized
        titleLabel.font = .primary(ofSize: StaticSize.size(22), weight: .semiBold)
        
        setUp()
    }
    
    func setUp() {
        contentView.addSubViews([mainScrollView, addButton])
        
        mainScrollView.snp.makeConstraints({
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })

        mainScrollView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        })
        
        addButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }

    func setSphere(sphere: SelectedSphere, index: Int) {
        (mainStackView.arrangedSubviews as? [InputView])?.first(where: {
            $0.viewType == .sphere
        })?.buttonInput.setText(
            text: Sphere.findByName(name: sphere.sphere ?? "").name,
            image: Sphere.findByName(name: sphere.sphere ?? "").icon
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(withBackButton: Bool = false, iconImage: UIImage? = nil) {
        fatalError("init(withBackButton:iconImage:) has not been implemented")
    }
}
