//
//  SpheresListView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/12/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class SpheresListView: View {
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = StaticSize.size(44)
        view.showsVerticalScrollIndicator = false
        view.register(SpheresListCell.self, forCellReuseIdentifier: SpheresListCell.reuseIdentifier)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: StaticSize.size(100), right: 0)
        view.separatorStyle = .none
        return view
    }()
    
    lazy var nextButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Next".localized, for: .normal)
        view.isActive = false
        return view
    }()
    
    required init() {
        super.init()
        backgroundColor = .white
        
        title = "Choose 3 spheres\nfor next 30 days".localized
        subtitle = "It might be changed in settings".localized
        
        titleLabel.font = .primary(ofSize: StaticSize.size(22), weight: .semiBold)
        subtitleLabel.textColor = .deepBlue
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(withBackButton: Bool = false, iconImage: UIImage? = nil) {
        fatalError("init(withBackButton:iconImage:) has not been implemented")
    }
    
    func setUp() {
        contentView.addSubViews([tableView, nextButton])
        
        tableView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(6))
            $0.left.right.bottom.equalToSuperview()
        })
        
        nextButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-(Global.safeAreaBottom() + StaticSize.size(15)))
            $0.left.right.equalToSuperview().inset(StaticSize.size(15))
            $0.height.equalTo(StaticSize.buttonHeight)
        })
    }
}
