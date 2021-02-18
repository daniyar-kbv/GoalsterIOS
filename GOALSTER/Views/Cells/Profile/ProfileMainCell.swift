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
    var count: Int? {
        didSet {
            guard let count = count else { return }
            circle.isHidden = count == 0
            number.text = "\(count)"
        }
    }
    
    var type: ProfileCellType? {
        didSet {
            title.text = type?.title
            arrow.isHidden = ModuleUserDefaults.getIsPremium() && type == .premium
            if let subtitle_ = type?.subtitle {
                subtitle.text = subtitle_
                titleStack.addArrangedSubview(subtitle)
            }
        }
    }
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .buttonPink
        view.layer.cornerRadius = StaticSize.size(8)
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        label.textColor = .deepBlue
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var subtitle: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(12), weight: .medium)
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var titleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [title])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(5)
        return view
    }()
    
    lazy var circle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = StaticSize.size(12)
        view.backgroundColor = .greatRed
        view.isHidden = true
        return view
    }()
    
    lazy var number: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(13), weight: .medium)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var arrow: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrowRight")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .deepBlue
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
        contentView.addSubViews([container])
        
        container.snp.makeConstraints({
            $0.top.bottom.equalToSuperview().inset(StaticSize.size(8))
            $0.left.right.equalToSuperview()
        })
        
        container.addSubViews([arrow, circle, titleStack])
        
        arrow.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(24))
            $0.width.equalTo(StaticSize.size(8))
            $0.height.equalTo(StaticSize.size(14))
            $0.centerY.equalToSuperview()
        })
        
        circle.snp.makeConstraints({
            $0.right.equalTo(arrow.snp.left).offset(-StaticSize.size(24))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(StaticSize.size(24))
        })
        
        circle.addSubViews([number])
        
        number.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(StaticSize.size(3))
        })
        
        titleStack.snp.makeConstraints({
            $0.right.left.equalToSuperview().inset(StaticSize.size(15))
            $0.centerY.equalToSuperview()
        })
    }
}
