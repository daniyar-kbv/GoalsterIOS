//
//  ObservedCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class ObservedCell: UITableViewCell {
    static let reuseIdentifier = "ObservedCell"
    
    var onAccept: ((_ button: UIButton, _ id: Int)->())?
    var onSelect: ((_ id: Int?)->())?
    
    var observed: Observed? {
        didSet {
            title.text = observed?.observed
            subtitle.text = observed?.spheres
            acceptButton.isHidden = observed?.isConfirmed != nil
            declineButton.isHidden = observed?.isConfirmed != nil
            arrow.isHidden = observed?.isConfirmed == nil
        }
    }
    
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
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(4)
        return view
    }()
    
    lazy var acceptButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "accept"), for: .normal)
        view.isHidden = true
        view.accessibilityIdentifier = "acceptButton"
//        view.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var declineButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "decline"), for: .normal)
        view.isHidden = true
        view.accessibilityIdentifier = "declineButton"
//        view.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var arrow: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var rightStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [acceptButton, declineButton, arrow])
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = StaticSize.size(8)
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
        addSubViews([rightStack, titleStack, topLine, bottomLine])
        
        rightStack.snp.makeConstraints({
            $0.right.centerY.equalToSuperview()
            $0.width.equalTo(StaticSize.size(56))
        })
        
        arrow.snp.makeConstraints({
            $0.width.equalTo(StaticSize.size(8))
            $0.height.equalTo(StaticSize.size(13))
        })
        
        acceptButton.snp.makeConstraints({
            $0.size.equalTo(StaticSize.size(24))
        })
        
        declineButton.snp.makeConstraints({
            $0.size.equalTo(StaticSize.size(24))
        })
        
        titleStack.snp.makeConstraints({
            $0.left.centerY.equalToSuperview()
            $0.right.equalTo(rightStack.snp.left)
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
    
    @objc func buttonTapped(_ sender: UIButton) {
        if let onAccept = onAccept, let id = observed?.id {
            onAccept(sender, id)
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: contentView) else { return }
        if rightStack.convert(acceptButton.frame, to: self).contains(location) || rightStack.convert(declineButton.frame, to: self).contains(location) {
            if let onAccept = onAccept, let id = observed?.id {
                onAccept(rightStack.convert(acceptButton.frame, to: self).contains(location) ? acceptButton : declineButton, id)
            }
        } else {
            onSelect?(observed?.id)
        }
    }
}
