//
//  ChatCell.swift
//  GOALSTER
//
//  Created by Dan on 2/11/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ChatCell: UITableViewCell {
    static let reuseIdentifier = "ChatCell"
    lazy var widthSet = false
    
    var comment: Comment? {
        didSet {
            isMine = comment?.sender?.email == ModuleUserDefaults.getEmail()
            senderLabel.text = isMine ?? false ? "You".localized : comment?.sender?.email
            senderLabel.textColor  = isMine ?? false ? .ultraPink : .strongGray
            commentLabel.text = comment?.text
            timeLabel.text = comment?.createdAt?.toDate(format: "dd-MM-yy HH:mm:ss")?.format(format: "HH:mm")
            container.alpha = comment?.isSent ?? true ? 1 : 0.5
            widthSet = false
            setUp()
        }
    }
    var isMine: Bool? {
        didSet {
            container.image = UIImage(named: isMine ?? false ? "commentRight" : "commentLeft")
        }
    }

    lazy var container: UIImageView = {
//        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH * 0.75, height: StaticSize.size(10000)))
        let view = UIImageView()
        return view
    }()
    
    lazy var senderLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(13), weight: .regular)
        return view
    }()
    
    lazy var commentLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.textColor = .darkBlack
        view.numberOfLines = 0
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(12), weight: .medium)
        view.textColor = UIColor.strongGray.withAlphaComponent(0.5)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if container.frame.width > ScreenSize.SCREEN_WIDTH * 0.75 {
            if widthSet {
                container.snp.updateConstraints({
                    $0.width.equalTo(ScreenSize.SCREEN_WIDTH * 0.75)
                })
            } else {
                container.snp.makeConstraints({
                    $0.width.equalTo(ScreenSize.SCREEN_WIDTH * 0.75)
                })
                widthSet = true
            }
        }
    }
    
    func setUp() {
        for view in contentView.subviews {
            view.removeFromSuperview()
            view.snp.removeConstraints()
        }
        
        for view in container.subviews {
            view.removeFromSuperview()
            view.snp.removeConstraints()
        }
        
        contentView.addSubViews([container])
        
        container.snp.makeConstraints({
            _ = isMine ?? false ?
                $0.right.equalToSuperview().offset(-StaticSize.size(4)) :
                $0.left.equalToSuperview().offset(StaticSize.size(4))
            $0.top.bottom.equalToSuperview().inset(StaticSize.size(5))
        })
        
        container.addSubViews([senderLabel, timeLabel, commentLabel])
        
        senderLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(4))
            $0.left.equalToSuperview().offset(isMine ?? false ? StaticSize.size(6) : StaticSize.size(17))
            $0.right.equalToSuperview().offset(isMine ?? false ? -StaticSize.size(17) : -StaticSize.size(6))
        })
        
        timeLabel.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-StaticSize.size(2))
            $0.right.equalToSuperview().offset(isMine ?? false ? -StaticSize.size(17) : -StaticSize.size(6)).priority(.high)
        })
        
        commentLabel.snp.makeConstraints({
            $0.left.equalToSuperview().offset(isMine ?? false ? StaticSize.size(6) : StaticSize.size(17))
            $0.top.equalTo(senderLabel.snp.bottom).offset(StaticSize.size(4))
            $0.right.equalTo(timeLabel.snp.left).offset(-StaticSize.size(4))
            $0.bottom.equalToSuperview().offset(-StaticSize.size(7))
        })
        
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
