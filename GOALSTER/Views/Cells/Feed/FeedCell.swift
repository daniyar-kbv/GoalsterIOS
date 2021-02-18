//
//  FeedCell.swift
//  GOALSTER
//
//  Created by Dan on 2/15/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import RxSwift

class FeedCell: UITableViewCell {
    static let reuseIdentifier = "FeedCell"
    
    let reactionsDelegate = ReactionCollectionViewDelegate()
    var user: FeedUser? {
        didSet {
            avatarView.kf.setImage(with: URL(string: user?.profile?.avatar ?? ""))
            nameLabel.text = user?.profile?.name
            specializationLabel.text = user?.profile?.specialization
            instagramButton.instagram = user?.profile?.instagramUsername
            reactionsDelegate.reactions = user?.reactions ?? []
            reactionsDelegate.userId = user?.id
            spheresCollection.reloadData()
        }
    }
    
    lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = StaticSize.size(10)
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(28), weight: .semiBold)
        view.textColor = .arcticWhite
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var specializationLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.textColor = .arcticWhite
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var titleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nameLabel, specializationLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = StaticSize.size(7)
        return view
    }()
    
    lazy var spheresCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        view.register(FeedSphereCell.self, forCellWithReuseIdentifier: FeedSphereCell.reuseIdentifier)
        view.layer.cornerRadius = StaticSize.size(10)
        view.backgroundColor = UIColor.arcticWhite.withAlphaComponent(0.4)
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var instagramButton: InstagramButton = {
        let view = InstagramButton()
        return view
    }()
    
    lazy var reactionsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        view.register(ReactionCell.self, forCellWithReuseIdentifier: ReactionCell.reuseIdentifier)
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        reactionsDelegate.collectionView = view
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.addGradientBackground(colors: [.clear, UIColor.black.withAlphaComponent(0.5)], locations: [0.5, 1.0], direction: .topToBottom)
    }
    
    func setUp(){
        contentView.addSubViews([avatarView, instagramButton, reactionsCollection])
        
        avatarView.snp.makeConstraints({
            $0.top.left.equalToSuperview()
            $0.size.equalTo(ScreenSize.SCREEN_WIDTH - StaticSize.size(54))
        })
        
        avatarView.addSubViews([spheresCollection, titleStack])
        
        spheresCollection.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-StaticSize.size(15))
            $0.left.right.equalToSuperview().inset(StaticSize.size(18))
            $0.height.equalTo(StaticSize.size(54))
        })
        
        titleStack.snp.makeConstraints({
            $0.bottom.equalTo(spheresCollection.snp.top).offset(-StaticSize.size(11))
            $0.left.right.equalToSuperview().inset(StaticSize.size(18))
        })
        
        instagramButton.snp.makeConstraints({
            $0.top.equalTo(avatarView.snp.bottom).offset(StaticSize.size(7))
            $0.centerX.equalToSuperview()
        })
        
        reactionsCollection.snp.makeConstraints({
            $0.top.equalTo(instagramButton.snp.bottom).offset(StaticSize.size(5))
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-StaticSize.size(25))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user?.selected?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedSphereCell.reuseIdentifier, for: indexPath) as! FeedSphereCell
        cell.index = indexPath.item
        cell.type = .feed
        cell.sphere = user?.selected?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(user?.selected?.count ?? 0), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class ReactionCollectionViewDelegate: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    lazy var viewModel = ReactionViewModel()
    lazy var disposeBag = DisposeBag()
    var userId: Int?
    var collectionView: UICollectionView? {
        didSet {
            collectionView?.delegate = self
            collectionView?.dataSource = self
        }
    }
    var reactions: [Reaction] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind()
    }
    
    func bind() {
        viewModel.reaction.subscribe(onNext: { object in
            DispatchQueue.main.async {
                guard let index = self.reactions.firstIndex(where: { $0.id == object.id }) else { return }
//                self.reactions[index] = object
//                self.collectionView?.reloadData()
            }
        }).disposed(by: disposeBag)
//        AppShared.sharedInstance.reaction.subscribe(onNext: { object in
//            DispatchQueue.main.async {
//                guard object.0 == self.userId else { return }
//                print("asd")
//                _ = self.reactions.map({
//                    if $0.id == object.1.id {
//                        print($0.id)
//                        print(object.1.id)
//                        $0.reacted = object.1.reacted
//                        print($0.count)
//                        $0.count = (object.1.reacted ?? false) ?
//                            ($0.count ?? 0) + 1 :
//                            ($0.count ?? 0) - 1
//                        print($0.count)
//                    } else if object.1.reacted ?? false && $0.reacted ?? false {
//                        $0.reacted = false
//                        $0.count = ($0.count ?? 0) - 1
//                    }
//                })
//                self.collectionView?.reloadData()
//            }
//        }).disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReactionCell.reuseIdentifier, for: indexPath) as! ReactionCell
        cell.index = indexPath.item
        cell.userId = userId
        cell.reaction = reactions[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(reactions.count), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let userId = userId, let reactionId = reactions[indexPath.item].id else { return }
        if ModuleUserDefaults.getIsLoggedIn() {
            reactions[indexPath.item].reacted?.toggle()
            if reactions[indexPath.item].reacted ?? false {
                animateReactions(view: collectionView.viewContainingController()?.view, emoji: reactions[indexPath.item].emoji)
            }
            viewModel.react(userId: userId, reactionId: reactionId)
            for (index, reaction) in reactions.enumerated() {
                if index == indexPath.item {
                    reactions[index].count = reactions[index].reacted ?? false ?
                        (reactions[index].count ?? 0) + 1 :
                        (reactions[index].count ?? 0) - 1
                } else if reactions[indexPath.item].reacted ?? false && reaction.reacted ?? false {
                    reactions[index].reacted = false
                    reactions[index].count = (reactions[index].count ?? 0) - 1
                }
            }
            
            if let vc = collectionView.viewContainingController()?.parent as? FeedDetailViewController, let index = vc.superVc.users.firstIndex(where: { $0.id == userId }), let delegate = (vc.superVc.mainView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FeedCell)?.reactionsDelegate {
                for (index, reaction) in delegate.reactions.enumerated() {
                    if index == indexPath.item {
                        delegate.reactions[index].reacted?.toggle()
                        delegate.reactions[index].count = delegate.reactions[index].reacted ?? false ?
                            (delegate.reactions[index].count ?? 0) + 1 :
                            (delegate.reactions[index].count ?? 0) - 1
                    } else if delegate.reactions[indexPath.item].reacted ?? false && reaction.reacted ?? false {
                        delegate.reactions[index].reacted = false
                        delegate.reactions[index].count = (delegate.reactions[index].count ?? 0) - 1
                    }
                }
                delegate.collectionView?.reloadData()
            }
            collectionView.reloadData()
//            AppShared.sharedInstance.reaction.onNext((userId, reactions[indexPath.item]))
        } else {
            present(FirstAuthViewController(), animated: true)
        }
    }
    
    func animateReactions(view: UIView?, emoji: String?) {
        var emojiViews: [UILabel] = []
        let numberOfIterations = 3
        let numberOfEmojis = 5
        let delay = 0.3
        let emojiSize = StaticSize.size(50)
        for _ in 0..<numberOfIterations * numberOfEmojis {
            let emojiLabel: UILabel = {
                let view = UILabel()
                view.font = .primary(ofSize: emojiSize, weight: .regular)
                view.text = emoji
                return view
            }()
            emojiViews.append(emojiLabel)
            view?.addSubview(emojiLabel)
            emojiLabel.snp.makeConstraints({
                $0.bottom.equalToSuperview().offset(emojiSize)
                $0.left.equalToSuperview().offset((ScreenSize.SCREEN_WIDTH - StaticSize.size(30)) * CGFloat.random(in: 0...1))
            })
        }
        
        view?.layoutIfNeeded()
        
        for i in 0..<numberOfIterations {
            for label in emojiViews[i * numberOfEmojis..<(i * numberOfEmojis) + numberOfEmojis] {
                label.snp.updateConstraints({
                    $0.bottom.equalToSuperview().offset(-((ScreenSize.SCREEN_HEIGHT * 0.5) * CGFloat.random(in: 0.2...1)))
                })
            }

            UIView.animate(withDuration: 1.5, delay: Double(i) * delay, options: .curveEaseOut, animations: {
                view?.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.5, delay: 1 + (Double(i) * delay), options: .curveEaseOut, animations: {
                for label in emojiViews[i * numberOfEmojis..<(i * numberOfEmojis) + numberOfEmojis] {
                    label.alpha = 0
                }
            }, completion: {
                if $0 {
                    for label in emojiViews[i * numberOfEmojis..<(i * numberOfEmojis) + numberOfEmojis] {
                        label.removeFromSuperview()
                    }
                }
            })
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InstagramButton: UIButton {
    var instagram: String? {
        didSet {
            instagramName.text = instagram
        }
    }
    
    lazy var instagramImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "instagram")
        view.isUserInteractionEnabled = false
        view.snp.makeConstraints({
            $0.size.equalTo(StaticSize.size(14))
        })
        return view
    }()
    
    lazy var instagramName: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.textColor = .deepBlue
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [instagramImage, instagramName])
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = StaticSize.size(5)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(openInstagram), for: .touchUpInside)
        
        setUp()
    }
    
    func setUp() {
        addSubViews([stackView])
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func openInstagram() {
        guard let instagram = instagram, let url = URL(string: "instagram://user?username=\(instagram)") else { return }
        UIApplication.shared.open(url)
    }
}
