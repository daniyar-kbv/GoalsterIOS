//
//  SegmentedView.swift
//  GOALSTER
//
//  Created by Dan on 2/8/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SegmentedView: UIView {
    var segments: [SegmentType]
    
    lazy var segmentControll: SegmentControll = {
        let view = SegmentControll(segments: segments)
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addGradientBackground()
    }
    
    required init(segments: [SegmentType]) {
        self.segments = segments
        
        super.init(frame: .zero)
        
        addSubViews([segmentControll, contentView])
        
        segmentControll.snp.makeConstraints({
            $0.top.equalToSuperview().offset(Global.safeAreaTop() + StaticSize.size(5))
            $0.centerX.equalToSuperview()
        })
        
        contentView.snp.makeConstraints({
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(segmentControll.snp.bottom).offset(StaticSize.size(5))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SegmentControll: UIStackView {
    var delegate: SegmentControllDelegate?
    var segments: [SegmentType]
    lazy var currentSegment: SegmentType! = segments.first
    
    required init(segments: [SegmentType]) {
        self.segments = segments
        
        super.init(frame: .zero)
        
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center
        spacing = StaticSize.size(7)
        
        for (index, segment) in segments.enumerated() {
            let button = SegmentButton(segment: segment)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.isActive = index == 0
            if index > 0 {
                addArrangedSubview(SegmentDelimiter())
            }
            addArrangedSubview(button)
        }
    }
    
    @objc func buttonTapped(_ button: SegmentButton) {
        delegate?.segmentTapped(button.segment)
        setCurrentSegment(segment: button.segment)
    }
    
    func setCurrentSegment(segment: SegmentType) {
        currentSegment = segment
        for button in (arrangedSubviews.filter({ $0 is SegmentButton }) as? [SegmentButton]) ?? [] {
            button.isActive = button.segment == segment
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SegmentButton: UIButton {
    var segment: SegmentType
    var isActive: Bool = false {
        didSet {
            setTitleColor(isActive ? .deepBlue : .middleBlue, for: .normal)
        }
    }
    
    required init(segment: SegmentType) {
        self.segment = segment
        
        super.init(frame: .zero)
        
        setTitle(segment.name, for: .normal)
        setTitleColor(.middleBlue, for: .normal)
        titleLabel?.font = .primary(ofSize: StaticSize.size(17), weight: .semiBold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SegmentDelimiter: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .borderGray
        
        snp.makeConstraints({
            $0.height.equalTo(StaticSize.size(13))
            $0.width.equalTo(StaticSize.size(1))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SegmentControllDelegate {
    func segmentTapped(_ segment: SegmentType)
}
