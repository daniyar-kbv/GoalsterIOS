//
//  AboutCell.swift
//  GOALSTER
//
//  Created by Dan on 2/15/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class AboutCell: UITableViewCell {
    static let reuseIdentifier = "AboutCell"
    
    var type: CellType? {
        didSet {
            titleLabel.text = type?.title
            subtitleLabel.text = type?.subtitle
        }
    }
    
    lazy var shadowContainer: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = StaticSize.size(4)
        view.layer.shadowOpacity = 0.07
        return view
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        view.layer.cornerRadius = StaticSize.size(8)
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.textColor = .deepBlue
        return view
    }()
    
    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(12), weight: .medium)
        view.textColor = .strongGray
        return view
    }()
    
    lazy var titleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(5)
        return view
    }()
    
    lazy var rightArrow: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrowRight")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .deepBlue
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setUp()
    }
    
    func setUp() {
        contentView.addSubViews([shadowContainer])
        
        shadowContainer.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.top.bottom.equalToSuperview().inset(StaticSize.size(6))
        })
        
        shadowContainer.addSubViews([container])
        
        container.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        container.addSubViews([rightArrow, titleStack])
        
        rightArrow.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(24))
            $0.width.equalTo(StaticSize.size(8.2))
            $0.height.equalTo(StaticSize.size(14))
            $0.centerY.equalToSuperview()
        })
        
        titleStack.snp.makeConstraints({
            $0.right.equalTo(rightArrow.snp.left).offset(-StaticSize.size(15))
            $0.left.equalToSuperview().offset(StaticSize.size(17))
            $0.centerY.equalToSuperview()
        })
    }
    
    enum CellType {
        case website
        case instagram
        case personalInstagram
        
        var title: String {
            switch self {
            case .website:
                return "www.24goalsapp.com"
            case .instagram:
                return "@24goalsapp"
            case .personalInstagram:
                return "@erkosha"
            }
        }
        
        var subtitle: String {
            switch self {
            case .website:
                return "Application site".localized
            case .instagram:
                return "Instagram application page".localized
            case .personalInstagram:
                return "Instagram founder page".localized
            }
        }
        
        var url: URL {
            switch self {
            case .website:
                return URL(string: "https://24goalsapp.com")!
            case .instagram:
                return URL(string: "instagram://user?username=24goalsapp")!
            case .personalInstagram:
                return URL(string: "instagram://user?username=erkosha")!
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
