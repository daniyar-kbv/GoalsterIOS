//
//  GoalInfoCell.swift
//  GOALSTER
//
//  Created by Dan on 2/11/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class GoalInfoCell: UITableViewCell {
    static let reuseIdentifier = "GoalInfoCell"
    enum CellType: CaseIterable {
        case sphere
        case time
        case status
        case isPublic
        case observer
        
        var name: String {
            switch self {
            case .sphere:
                return "Sphere".localized
            case .time:
                return "Time".localized
            case .status:
                return "Status".localized
            case .isPublic:
                return "Public".localized
            case .observer:
                return "Mentor".localized
            }
        }
    }
    var type: CellType?
    var goal: Goal? {
        didSet {
            switch type {
            case .sphere:
                titleLabel.text = "\(type?.name ?? ""): \((ModuleUserDefaults.getSpheres()?[(goal?.sphere?.rawValue ?? 1) - 1].sphere ?? "").lowercased())"
            case .time:
                titleLabel.text = "\(type?.name ?? ""): \(String(describing: goal?.time?.toStr.lowercased() ?? ""))"
            case .status:
                titleLabel.text = "\(type?.name ?? ""): \((goal?.isDone ?? false ? "Done" : "In process").localized.lowercased())"
            case .isPublic:
                titleLabel.text = "\(type?.name ?? ""): \((goal?.isPublic ?? false ? "Yes" : "No").localized.lowercased())"
            case .observer:
                titleLabel.text = "\(type?.name ?? ""): \((goal?.observer != nil ? goal?.observer?.email : "No".localized.lowercased()) ?? "")"
            default:
                break
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .primary(ofSize: StaticSize.size(12), weight: .medium)
        view.textColor = .deepBlue
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setUp()
    }
    
    func setUp() {
        contentView.addSubViews([titleLabel])
        
        titleLabel.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.centerY.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
