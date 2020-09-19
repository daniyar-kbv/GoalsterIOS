//
//  CollectionIndicatorView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/18/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class CollectionIndicatorView: UIStackView {
    class Item: UIView {
        var isActive = false {
            didSet {
                innerView.backgroundColor = isActive ? .customActivePurple : .white
            }
        }
        
        lazy var innerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = StaticSize.size(2)
            view.layer.masksToBounds = true
            return view
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowRadius = StaticSize.size(3)
            layer.shadowOffset = CGSize(width: 0, height: StaticSize.size(2))
            layer.shadowOpacity = 0.15
            
            addSubViews([innerView])
            
            innerView.snp.makeConstraints({
                $0.edges.equalToSuperview()
            })
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    var number: Int {
        didSet {
            setUp()
        }
    }
    
    required init(number: Int) {
        self.number = number
        
        super.init(frame: .zero)
        
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = StaticSize.size(6)
        
        setUp()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        
        for _ in 0..<number {
            let view: Item = {
                let view = Item()
                return view
            }()
            
            addArrangedSubview(view)
        }
    }
    
    func setProgress(number: Int?, animated: Bool = true) {
        if let number = number {
            for (index, view) in arrangedSubviews.enumerated() {
                let view = view as! Item
                UIView.animate(withDuration: animated ? 0.1 : 0, animations: {
                    view.isActive = index == (number - 1)
                })
            }
        }
    }
}
