//
//  GoalDetailView.swift
//  GOALSTER
//
//  Created by Dan on 2/11/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class GoalDetailView: UIView {
    var goal: Goal {
        didSet {
            descriptionLabel.text = goal.name
            infoTableView.reloadData()
        }
    }
    var vc: GoalDetailViewController
    var infoShowed = false {
        didSet {
            infoArrowImage.image = UIImage(named: infoShowed ? "arrowUp" : "arrowDown")
            
            infoTableView.snp.updateConstraints({
                $0.height.equalTo(
                    infoShowed ?
                        CGFloat(infoTableView.numberOfRows(inSection: 0)) * infoTableView.rowHeight :
                        0
                )
            })
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.layoutIfNeeded()
            })
        }
    }
    
    lazy var infoButton: UIButton = {
        let view = UIButton()
        return view
    }()
    
    lazy var infoTitle: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .bold)
        view.textColor = .deepBlue
        view.text = "Info".localized
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var infoArrowImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrowDown")
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var infoTableView: UITableView = {
        let view = UITableView()
        view.register(GoalInfoCell.self, forCellReuseIdentifier: GoalInfoCell.reuseIdentifier)
        view.rowHeight = StaticSize.size(25)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(17), weight: .bold)
        view.textColor = .ultraGray
        view.numberOfLines = 0
        view.text = goal.name
        return view
    }()
    
    lazy var fakeTextField: FakeTextField = {
        let view = FakeTextField()
        view.textViewToOpen = chatTextView
        view.inputAccessoryView = chatView
        return view
    }()
    
    lazy var chatTableView: UITableView = {
        let view = UITableView()
        view.register(ChatCell.self, forCellReuseIdentifier: ChatCell.reuseIdentifier)
        view.estimatedRowHeight = StaticSize.size(55)
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var chatView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: StaticSize.size(10), height: StaticSize.size(120)))
        view.backgroundColor = .iOSLightGray
        return view
    }()
    
    lazy var chatTextView: ChatTextView = {
        let view = ChatTextView(placeholder: "Comment...".localized)
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "sendComment"), for: .normal)
        return view
    }()
    
    required init(goal: Goal, vc: GoalDetailViewController) {
        self.goal = goal
        self.vc = vc
        
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubViews([infoButton, infoTableView, descriptionLabel])
        
        infoButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(16))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        infoButton.addSubViews([infoTitle, infoArrowImage])
        
        infoTitle.snp.makeConstraints({
            $0.top.left.bottom.equalToSuperview()
        })
        
        infoArrowImage.snp.makeConstraints({
            $0.left.equalTo(infoTitle.snp.right).offset(StaticSize.size(10))
            $0.centerY.equalToSuperview()
            $0.width.equalTo(StaticSize.size(10.5))
            $0.height.equalTo(StaticSize.size(6))
        })
        
        infoTableView.snp.makeConstraints({
            $0.top.equalTo(infoButton.snp.bottom).offset(StaticSize.size(5))
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0)
        })
        
        descriptionLabel.snp.makeConstraints({
            $0.top.equalTo(infoTableView.snp.bottom).offset(StaticSize.size(7))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
        })
        
        if goal.observer != nil {
            addSubViews([fakeTextField, chatTableView])
            
            chatView.addSubViews([chatTextView, sendButton])
            
            sendButton.snp.makeConstraints({
                $0.right.equalToSuperview().offset(-StaticSize.size(17))
                $0.bottom.equalToSuperview().offset(-StaticSize.size(8))
                $0.size.equalTo(StaticSize.size(27))
            })
            
            chatTextView.snp.makeConstraints({
                $0.left.equalToSuperview().offset(StaticSize.size(15))
                $0.top.bottom.equalToSuperview().inset(StaticSize.size(5))
                $0.right.equalTo(sendButton.snp.left).offset(StaticSize.size(-9))
            })
            
            chatTableView.snp.makeConstraints({
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(StaticSize.size(10))
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(0)
            })
        }
    }
}

class FakeTextField: UITextView, UITextViewDelegate {
    var textViewToOpen: UITextView?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewToOpen?.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatTextView: UITextView, UITextViewDelegate {
    var placeholder: String
    var lastHeight: CGFloat?
    var onBegin: (()->())?
    var onEnd: (()->())?
    var onChange: (()->())?
    var isEmpty = true
    
    required init(placeholder: String) {
        self.placeholder = placeholder
        
        super.init(frame: .zero, textContainer: .none)
        
        layer.cornerRadius = StaticSize.size(5)
        layer.borderWidth = StaticSize.size(1)
        layer.borderColor = UIColor.borderGray.cgColor
        
        textColor = .strongGray
        text = placeholder
        isUserInteractionEnabled = false
        font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        
        textContainerInset = UIEdgeInsets(top: StaticSize.size(8), left: StaticSize.size(8), bottom: StaticSize.size(1.5), right: StaticSize.size(8))
        
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        onBegin?()
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        superview?.snp.updateConstraints({
            $0.height.equalTo(newSize.height + StaticSize.size(16))
        })
        superview?.layoutIfNeeded()
        let newPosition = beginningOfDocument
        selectedTextRange = textRange(from: newPosition, to: newPosition)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        onEnd?()
    }
    
    func textViewDidChange(_ textView: UITextView){
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        superview?.snp.updateConstraints({
            $0.height.equalTo(newSize.height + StaticSize.size(16))
        })
        superview?.layoutIfNeeded()
        onChange?()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if isEmpty && text != "" {
            isEmpty = false
            textView.text = ""
            textColor = .darkBlack
            isUserInteractionEnabled = true
            return true
        }
        return true
    }
}
