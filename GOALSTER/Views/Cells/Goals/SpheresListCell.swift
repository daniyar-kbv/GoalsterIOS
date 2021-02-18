//
//  SpheresListCell.swift
//  GOALSTER
//
//  Created by Daniyar on 8/12/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SpheresListCell: UITableViewCell {
    lazy var disposeBag = DisposeBag()
    
    static let reuseIdentifier = "SpheresListCell"
    var isActive: Bool = false {
        didSet {
            radio.image = isActive ? UIImage(named: "radio_active") : UIImage(named: "radio_inactive")
        }
    }
    var sphere: Sphere? {
        didSet {
            icon.image = sphere?.icon
            if sphere == .addOwnOption{
                nameField.placeholder = sphere?.name ?? ""
                nameField.isUserInteractionEnabled = true
            } else {
                nameField.text = sphere?.name
                nameField.isUserInteractionEnabled = false
            }
        }
    }
    var onChange: ((_ text: String?)->())? 
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var nameField: BaseTextField = {
        let label = BaseTextField()
        label.font = .primary(ofSize: StaticSize.size(18), weight: .medium)
        label.textColor = .deepBlue
        label.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return label
    }()
    
    lazy var radio: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "radio_inactive")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)
        
        selectionStyle = .none
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        contentView.addSubViews([icon, radio, nameField])
        
        icon.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(15))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(StaticSize.size(20))
        })
        
        radio.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(StaticSize.size(18))
        })
        
        nameField.snp.makeConstraints({
            $0.left.equalTo(icon.snp.right).offset(StaticSize.size(8))
            $0.centerY.equalToSuperview()
            $0.right.equalTo(radio.snp.left).offset(-StaticSize.size(15))
        })
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        onChange?(textField.text)
    }
}
