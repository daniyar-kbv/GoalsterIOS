//
//  OnBoardingCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class OnBoardingCell: UICollectionViewCell {
    static let reuseIdentifier = "OnBoardingCell"
    
    enum ViewType: Int {
        case first
        case second
        case third
        case fourth
        
        var image: UIImage? {
            return UIImage(named: "onBoarding\(rawValue + 1)")
        }
        
        var title: String {
            return "On boarding top text \(rawValue + 1)".localized
        }
        
        var text: String {
            return "On boarding bottom text \(rawValue + 1)".localized
        }
        
        var imageSize: CGSize {
            switch self {
            case .first:
                return CGSize(width: StaticSize.size(284), height: StaticSize.size(189))
            case .second:
                return CGSize(width: StaticSize.size(252), height: StaticSize.size(191))
            case .third:
                return CGSize(width: StaticSize.size(210), height: StaticSize.size(182))
            case .fourth:
                return CGSize(width: StaticSize.size(233), height: StaticSize.size(167))
            }
        }
    }
    
    var type: ViewType? {
        didSet {
            imageView.image = type?.image
            topText.text = type?.title
            bottomText.text = type?.text
            imageView.snp.makeConstraints({
                $0.width.equalTo(type?.imageSize.width ?? 0)
                $0.height.equalTo(type?.imageSize.height ?? 0)
            })
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = StaticSize.size(20)
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var topText: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .primary(ofSize: StaticSize.size(20), weight: .semiBold)
        view.textColor = .deepBlue
        view.numberOfLines = 0
        return view
    }()
    
    lazy var bottomText: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .primary(ofSize: StaticSize.size(17), weight: .regular)
        view.textColor = .ultraGray
        view.numberOfLines = 0
        return view
    }()
    
    lazy var textStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [topText, bottomText])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(13)
        return view
    }()
    
    lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView, textStack])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = StaticSize.size(80)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([backView])
        
        backView.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(StaticSize.size(10))
        })
        
        backView.addSubViews([mainStack])
        
        mainStack.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.centerY.equalToSuperview()
        })
    }
}
