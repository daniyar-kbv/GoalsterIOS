//
//  PlanView.swift
//  GOALSTER
//
//  Created by Dan on 9/28/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class PlanView: UIStackView {
    let viewType: ViewType
    let planType: PlanType
    let price: String
    var buttonTapped: ((PlanView.PlanType) -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .deepBlue
        view.textAlignment = .center
        switch viewType {
        case .filled:
            view.text = planType.title.uppercased()
            view.font = .primary(ofSize: StaticSize.size(20), weight: .regular)
        case .empty:
            view.text = planType.title
            view.font = .primary(ofSize: StaticSize.size(15), weight: .bold)
        }
        return view
    }()
    
    private lazy var button: Button = {
        let view = Button(viewType: viewType)
        view.setTitle(price, for: .normal)
        view.layer.cornerRadius = StaticSize.size(22)
        view.layer.borderWidth = StaticSize.size(1.1)
        view.layer.borderColor = UIColor.middlePink.cgColor
        view.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        switch viewType {
        case .filled:
            view.setTitleColor(.arcticWhite, for: .normal)
            view.titleLabel?.font = .primary(ofSize: StaticSize.size(14), weight: .medium)
        case .empty:
            view.setTitleColor(.deepBlue, for: .normal)
            view.titleLabel?.font = .primary(ofSize: StaticSize.size(14), weight: .semiBold)
        }
        return view
    }()
    
    init(viewType: ViewType, planType: PlanType, price: String) {
        self.viewType = viewType
        self.planType = planType
        self.price = price
        
        super.init(frame: .zero)
        
        axis = .vertical
        distribution = .equalSpacing
        alignment = .fill
        
        switch viewType {
        case .filled: spacing = StaticSize.size(2)
        case .empty: spacing = StaticSize.size(8)
        }
        
        addArrangedSubViews([titleLabel, button])
        
        button.snp.makeConstraints({
            $0.height.equalTo(StaticSize.size(44))
        })
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap() {
        buttonTapped?(planType)
    }
    
    enum ViewType {
        case filled
        case empty
    }
    
    enum PlanType: String {
        case forever = "com.goalsterapp.forever.4"
        case oneMonth = "com.goalsterapp.onemonth.4"
        case oneYear = "com.goalsterapp.oneyear.4"
        
        var title: String {
            switch self {
            case .forever: return "PayBall.plan.forever".localized
            case .oneMonth: return "PayBall.plan.oneMonth".localized
            case .oneYear: return "PayBall.plan.oneYear".localized
            }
        }
    }
    
    class Button: CustomButton {
        let viewType: ViewType
        
        init(viewType: ViewType) {
            self.viewType = viewType
            
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func toNormal() {
            switch viewType {
            case .filled: super.toNormal()
            case .empty:
                backgroundColor = .arcticWhite
                isUserInteractionEnabled = true
            }
        }
        
        override func toDisabled() {
            switch viewType {
            case .filled: super.toDisabled()
            case .empty:
                backgroundColor = .lightGray
                isUserInteractionEnabled = false
            }
        }
        
        override func toPressed() {
            switch viewType {
            case .filled: super.toPressed()
            case .empty: backgroundColor = .lightGray
            }
        }
    }
}
