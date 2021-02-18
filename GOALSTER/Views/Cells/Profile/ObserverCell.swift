//
//  ObserverCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ObserverCell: UITableViewCell {
    static let reuseIdentifier = "ObserverCell"
    
    var onTap: ((_ id: Int)->())?
    
    var observer: Observer? {
        didSet {
            title.text = observer?.observer
        }
    }
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .primary(ofSize: StaticSize.size(20), weight: .medium)
        label.textColor = .ultraGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "trash"), for: .normal)
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
        addSubViews([deleteButton, title, topLine, bottomLine])
        
        deleteButton.snp.makeConstraints({
            $0.right.centerY.equalToSuperview()
            $0.size.equalTo(StaticSize.size(32))
        })
        
        title.snp.makeConstraints({
            $0.left.centerY.equalToSuperview()
            $0.right.equalTo(deleteButton.snp.left).offset(-StaticSize.size(5))
        })
        
        topLine.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
        })
        
        bottomLine.snp.makeConstraints({
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
        })
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: contentView) else { return }
        if deleteButton.frame.contains(location) {
            if let onTap = onTap, let id = observer?.id {
                onTap(id)
            }
        }
    }
}

