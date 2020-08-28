//
//  GoalsCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/16/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class GoalsCell: UITableViewCell {
    static let reuseIdentifier = "GoalsCell"
    
    var goal: Goal? {
        didSet {
            switch goal?.sphere {
            case .first:
                leftView.backgroundColor = .customGoalRed
            case .second:
                leftView.backgroundColor = .customGoalYellow
            case .third:
                leftView.backgroundColor = .customGoalGreen
            default:
                break
            }
            statusLabel.text = goal?.isDone ?? false ? "Done".localized : "In process".localized
            radio.setBackgroundImage(goal?.isDone ?? false ? UIImage(named: "radio_active") : UIImage(named: "radio_inactive"), for: .normal)
            textView.text = goal?.name
            if [nil, true].contains(goal?.isConfirmed) && goal?.observer != nil {
                observationView.isHidden = false
                observationView.observer = goal?.observer
                observationView.isActive = goal?.isConfirmed
                mainStack.addArrangedSubview(observationView)
            }
        }
    }
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var leftView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var statusLabel: UILabel = {
        let view = UILabel()
        view.font = .gotham(ofSize: StaticSize.size(12), weight: .book)
        view.textColor = .customTextBlack
        return view
    }()
    
    lazy var radio: UIButton = {
        let view = UIButton()
        return view
    }()
    
    lazy var textView: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.font = .gotham(ofSize: StaticSize.size(13), weight: .medium)
        view.textColor = .customTextBlack
        return view
    }()
    
    lazy var viewForText: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    lazy var observationView: ObservationSmallView = {
        let view = ObservationSmallView()
        view.isHidden = true
        return view
    }()
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [statusLabel, viewForText])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .leading
        view.spacing = StaticSize.size(15)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([container])
        
        container.snp.makeConstraints({
            $0.top.bottom.equalToSuperview().inset(StaticSize.size(8))
            $0.left.equalToSuperview().offset(StaticSize.size(42))
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
        })
        
        container.addSubViews([leftView, mainStack, radio])
        
        leftView.snp.makeConstraints({
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(StaticSize.size(4))
        })
        
        mainStack.snp.makeConstraints({
            $0.left.equalTo(leftView.snp.right).offset(StaticSize.size(8))
            $0.right.top.bottom.equalToSuperview().inset(StaticSize.size(8))
        })
        
        viewForText.addSubViews([textView])
        
        textView.snp.makeConstraints({
            $0.top.right.left.equalToSuperview()
            $0.bottom.equalToSuperview().offset(StaticSize.size(15))
        })
        
        radio.snp.makeConstraints({
            $0.top.right.equalToSuperview().inset(StaticSize.size(8))
            $0.size.equalTo(StaticSize.size(20))
        })
    }
    
    override func prepareForReuse() {
        observationView.removeFromSuperview()
    }
}
