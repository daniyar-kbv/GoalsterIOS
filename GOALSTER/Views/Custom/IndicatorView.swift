//
//  IndicatorView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/10/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class IndicatorView: UIStackView {
    var number: Int
    var indicators: [UIImageView] = []
    
    required init(number: Int) {
        self.number = number
        for i in 0..<number{
            let new: UIImageView = {
                let view = UIImageView()
                view.image = UIImage(named: i == 0 ? "dot" : "muted")
                return view
            }()
            indicators.append(new)
        }
        
        super.init(frame: CGRect())
        
        setUp()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addArrangedSubViews(indicators)
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center
        
        for indicator in indicators {
            indicator.snp.makeConstraints({
                $0.size.equalTo(StaticSize.size(8))
            })
        }
    }
    
    func setCurrent(index: Int){
        UIView.animate(withDuration: 0.2, animations: {
            for (i, indicator) in self.indicators.enumerated(){
                indicator.image = UIImage(named: index == i ? "dot" : "muted")
            }
        })
    }
}
