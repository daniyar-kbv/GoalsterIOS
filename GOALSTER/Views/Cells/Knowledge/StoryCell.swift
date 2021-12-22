//
//  StoryCell.swift
//  GOALSTER
//
//  Created by Dan on 9/21/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol StoryCellDelegate: AnyObject {
    func buttonTapped(id: Int)
}

class StoryCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()
    private var id: Int?
    
    weak var delegate: StoryCellDelegate?
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentInset = .init(top: StaticSize.size(16),
                                  left: 0,
                                  bottom: Global.safeAreaBottom() + StaticSize.size(72),
                                  right: 0)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var container: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var textView: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(15), weight: .regular)
        view.textColor = .deepBlue
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var bottomButton: CustomButton = {
        let view = CustomButton()
        view.titleLabel?.font = .primary(ofSize: StaticSize.size(15), weight: .semiBold)
        view.setTitle("Story.Button.title".localized, for: .normal)
        view.rx
            .tap
            .bind(onNext: { [weak self] in
                guard let id = self?.id else { return }
                self?.delegate?.buttonTapped(id: id)
            })
            .disposed(by: disposeBag)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.addSubViews([scrollView, bottomButton])
        
        scrollView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        scrollView.addSubViews([container])
        
        container.snp.makeConstraints({
            $0.edges.width.equalToSuperview()
        })
        
        container.addSubViews([imageView, textView])
        
        imageView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(StaticSize.size(20))
        })
        
        textView.snp.makeConstraints({
            $0.top.equalTo(imageView.snp.bottom).offset(StaticSize.size(16))
            $0.left.right.equalToSuperview().inset(StaticSize.size(20))
            $0.bottom.equalToSuperview()
        })
        
        bottomButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(16)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(95))
            $0.height.equalTo(StaticSize.size(40))
        })
    }
}

extension StoryCell {
    func set(id: Int, imageURL: URL?, text: String) {
        self.id = id
        imageView.kf.setImage(with: imageURL)
        textView.text = text
    }
}
