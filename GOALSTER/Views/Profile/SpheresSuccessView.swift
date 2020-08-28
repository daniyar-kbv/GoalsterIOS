//
//  SpheresSuccessView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/24/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class SpheresSuccessView: UIView  {
    lazy var topBrush: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.5
        view.isHidden = true
        return view
    }()
    
    lazy var image: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ok")
        return view
    }()
    
    lazy var text: CustomLabelWithoutPadding = {
        let view = CustomLabelWithoutPadding()
        view.text = "Shreres changed successfully".localized
        view.font = .gotham(ofSize: StaticSize.size(16), weight: .book)
        view.textColor = .customTextDarkPurple
        view.textAlignment = .center
        return view
    }()
    
    lazy var button: CustomButton = {
        let view = CustomButton()
        view.setTitle("Back to profile".localized, for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([topBrush, image, text, button])
        
        topBrush.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(5)
            $0.width.equalTo(45)
            $0.centerX.equalToSuperview()
        })
        
        image.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(167))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(StaticSize.size(93))
            $0.height.equalTo(StaticSize.size(169))
        })
        
        text.snp.makeConstraints({
            $0.top.equalTo(image.snp.bottom).offset(StaticSize.size(33))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        button.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
}
