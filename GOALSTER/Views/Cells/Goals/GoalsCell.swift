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
    var indexPath: IndexPath?
    var onDone: ((_ indexPath: IndexPath)->())?
    
    var goal: Goal? {
        didSet {
            switch goal?.sphere {
            case .first:
                leftView.backgroundColor = .greatRed
            case .second:
                leftView.backgroundColor = .goodYellow
            case .third:
                leftView.backgroundColor = .calmGreen
            default:
                break
            }
            statusLabel.text = goal?.isDone ?? false ? "Done".localized : "In process".localized
            statusLabel.textColor = goal?.isDone ?? false ? .wildGreen : .darkBlack
            radio.setBackgroundImage(goal?.isDone ?? false ? UIImage(named: "radio_active") : UIImage(named: "radio_inactive"), for: .normal)
            textView.text = goal?.name
            if ([nil, true].contains(goal?.isConfirmed) && goal?.observer != nil) || goal?.isPublic ?? false || goal?.newComment ?? false {
                observationView.isHidden = false
                observationView.goal = goal
                mainStack.addArrangedSubview(observationView)
            }
        }
    }
    
    lazy var shadowContainer: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: StaticSize.size(5))
        view.layer.shadowRadius = StaticSize.size(10)
        view.layer.shadowOpacity = 0.07
        return view
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .arcticWhite
        view.layer.cornerRadius = StaticSize.size(10)
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var leftView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var statusLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(12), weight: .medium)
        view.textColor = .ultraGray
        return view
    }()
    
    lazy var radio: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        view.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return view
    }()
    
    lazy var textView: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(12), weight: .medium)
        view.textColor = .darkBlack
        view.numberOfLines = 0
        return view
    }()
    
    lazy var viewForText: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    lazy var observationView: GoalStatusView = {
        let view = GoalStatusView()
        view.isHidden = true
        return view
    }()
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [statusLabel, textView])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(10)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        setUp()
    }
    
    @objc func doneTapped() {
        guard let indexPath = indexPath else { return }
        onDone?(indexPath)
    }
    
    func setUp() {
        contentView.addSubViews([shadowContainer])
        
        shadowContainer.snp.makeConstraints({
            $0.top.bottom.equalToSuperview().inset(StaticSize.size(7))
            $0.left.equalToSuperview().offset(StaticSize.size(21))
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
        })
        
        shadowContainer.addSubViews([container])
        
        container.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        container.addSubViews([leftView, mainStack, radio])
        
        leftView.snp.makeConstraints({
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(StaticSize.size(4))
        })
        
        mainStack.snp.makeConstraints({
            $0.left.equalTo(leftView.snp.right).offset(StaticSize.size(8))
            $0.top.equalToSuperview().inset(StaticSize.size(12))
            $0.bottom.equalToSuperview().offset(-StaticSize.size(9))
            $0.right.equalToSuperview().inset(StaticSize.size(13))
        })
        
        radio.snp.makeConstraints({
            $0.top.equalToSuperview().inset(StaticSize.size(8))
            $0.right.equalToSuperview().offset(-StaticSize.size(13))
            $0.size.equalTo(StaticSize.size(20))
        })
    }
    
    override func prepareForReuse() {
        observationView.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
