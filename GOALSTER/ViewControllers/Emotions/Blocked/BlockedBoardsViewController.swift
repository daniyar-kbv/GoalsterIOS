//
//  BlockedBoardsViewController.swift
//  GOALSTER
//
//  Created by Dan on 9/19/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

class BlockedBoardsViewController: ProfileFirstViewController {
    private lazy var contentView = BlockedBoardsView(type: type)
    private let type: BlockedBoardType
    
    var onSuccess: (() -> ())?
    
    init(type: BlockedBoardType) {
        self.type = type
        
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        setView(contentView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.delegate = self
        
        baseView.titleLabel.font = .primary(ofSize: StaticSize.size(32), weight: .black)
        baseView.titleLabel.textColor = .deepBlue
        setTitle(type.title)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        baseView.addGradientBackground(colors: [.init(hex: "#E8E8EB"), .init(hex: "#FFFFFF")], locations: [0, 1], direction: .topToBottom)
    }
}

extension BlockedBoardsViewController: BlockedBoardsViewDelegate {
    func buttonTapped() {
        let premiumVC = PresentablePremiumViewController()
        premiumVC.setOnSuccess { [weak self] in
            premiumVC.dismiss(animated: true) {
                self?.onSuccess?()
            }
        }
        present(premiumVC, animated: true)
    }
}
