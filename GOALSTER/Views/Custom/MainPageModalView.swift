////
////  CustomModalView.swift
////  Samokat
////
////  Created by Daniyar on 7/9/20.
////  Copyright © 2020 MTI. All rights reserved.
////
//
//import Foundation
//import UIKit
//import SnapKit
//
//class MainPageModalView: UIView{
//    lazy var tableView: UITableView = {
//        let view = UITableView()
//        view.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.customReuseIdentifier)
//        view.delaysContentTouches = false
//        view.separatorStyle = .none
//        view.showsVerticalScrollIndicator = false
//        return view
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        setUp()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setUp() {
//        addSubViews([tableView])
//        tableView.snp.makeConstraints({
//            $0.edges.equalToSuperview()
//        })
//    }
//}
