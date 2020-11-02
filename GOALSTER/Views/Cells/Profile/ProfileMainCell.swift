//
//  ProfileMainView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ProfileMainCell: UITableViewCell {
    static let reuseIdentifier = "ProfileMainCell"
    
    var type: ProfileCellType? {
        didSet {
            container.isHidden = type == .empty
            arrowDirection = type?.arrowDirection
            title.text = type?.title
            subtitle.text = type?.subtitle
            arrow.isHidden = ModuleUserDefaults.getIsPremium() && type == .premium
        }
    }
    
    var arrowDirection: ArrowDirection? {
        didSet {
            switch arrowDirection {
            case .right:
                arrow.image = UIImage(named: "arrowRight")
                arrow.snp.makeConstraints({
                    $0.width.equalTo(StaticSize.size(8))
                    $0.height.equalTo(StaticSize.size(13))
                })
            case .down:
                arrow.image = UIImage(named: "arrowDownGray")
                arrow.snp.makeConstraints({
                    $0.width.equalTo(StaticSize.size(13))
                    $0.height.equalTo(StaticSize.size(8))
                })
            default:
                break
            }
        }
    }
    
    lazy var container: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(20), weight: .medium)
        label.textColor = .customTextBlack
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var subtitle: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(12), weight: .medium)
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var titleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [title, subtitle])
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.spacing = StaticSize.size(4)
        return view
    }()
    
    lazy var circle: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "circle")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .customLightRed
        view.isHidden = true
        return view
    }()
    
    lazy var number: UILabel = {
        let label = UILabel()
        label.font = .gotham(ofSize: StaticSize.size(16), weight: .medium)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var arrow: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.isHidden = true
        return view
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([container, topLine, bottomLine])
        
        container.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        topLine.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
        })
        
        bottomLine.snp.makeConstraints({
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
        })
        
        container.addSubViews([arrow, circle, titleStack])
        
        arrow.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(11))
            $0.centerY.equalToSuperview()
        })
        
        circle.snp.makeConstraints({
            $0.right.equalTo(arrow.snp.left).offset(-StaticSize.size(21))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(StaticSize.size(28))
        })
        
        circle.addSubViews([number])
        
        number.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(StaticSize.size(3))
        })
        
        titleStack.snp.makeConstraints({
            $0.left.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(StaticSize.size(8))
            $0.right.equalTo(arrow.snp.left).offset(-StaticSize.size(10))
        })
    }
}
