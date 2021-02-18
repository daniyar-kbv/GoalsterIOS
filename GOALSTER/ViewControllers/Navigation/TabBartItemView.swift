//
//  TabBartItemView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class TabBarItemView: UIView {
    var item: TabItem
    var isActive: Bool? {
        didSet {
            guard let isActive = isActive else { return }
            UIView.animate(withDuration: 0.2, animations: { [self] in
                itemIconView.tintColor = isActive ? .ultraPink : .middleGray
            })
        }
    }
    
    lazy var itemIconView: UIImageView = {
        let view = UIImageView()
        view.image = item.icon.withRenderingMode(.alwaysTemplate)
        view.tintColor = .middleGray
        return view
    }()
    
    required init(item: TabItem) {
        self.item = item
        
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([itemIconView])
        
        itemIconView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(StaticSize.size(7))
            $0.size.equalTo(StaticSize.size(24))
        })
    }
}
