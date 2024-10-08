//
//  TabNavigationMenu.swift
//  GOALSTER
//
//  Created by Daniyar on 8/11/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

class TabNavigationMenu: UIView {
    
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(menuItems: [TabItem], frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        for i in 0 ..< menuItems.count {
            let itemWidth = frame.width / CGFloat(menuItems.count)
            let leftOffset = itemWidth * CGFloat(i)
            
            let itemView = createTabItem(item: menuItems[i])
            itemView.tag = i
            
            addSubview(itemView)
            
            itemView.snp.makeConstraints({
                $0.height.top.equalTo(self)
                $0.left.equalTo(self).offset(leftOffset)
                $0.width.equalTo(itemWidth)
            })
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        activateTab(tab: 0)
    }
    
    func createTabItem(item: TabItem) -> UIView {
        let tabBarItem = TabBarItemView(item: item)
        
        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        
        return tabBarItem
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.switchTab(from: activeItem, to: sender.view!.tag)
    }
    
    func switchTab(from: Int, to: Int, completion: ((Bool) -> Void)? = nil) {
        if !ModuleUserDefaults.getIsLoggedIn() && to == 3 {
            let vc = UIApplication.topViewController()
            vc?.present(FirstAuthViewController(), animated: true, completion: nil)
        } else {
            deactivateTab(tab: from)
            activateTab(tab: to, completion: completion)
        }
    }
    
    func activateTab(tab: Int, completion: ((Bool) -> Void)? = nil) {
        let tabToActivate = subviews[tab] as? TabBarItemView
        UIView.animate(withDuration: 0, animations: {
            tabToActivate?.isActive = true
            self.itemTapped?(tab)
        }, completion: completion)
        activeItem = tab
    }
    
    func deactivateTab(tab: Int) {
        let inactiveTab = subviews[tab] as? TabBarItemView
        inactiveTab?.isActive = false
    }
}
