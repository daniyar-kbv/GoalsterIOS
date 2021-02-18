//
//  ObservedCalendarView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ObservedCalendarViewController: ProfileBaseViewController {
    lazy var calendarViewController = CalendarBaseViewController()
    lazy var viewModel = ObservedCalendarViewModel()
    lazy var disposeBag = DisposeBag()
    lazy var selectedDate = Date()
    var observation: Int
    
    var items: [CaledarItem]? {
        didSet {
            calendarViewController.items = items
        }
    }
    
    required init(observation: Int) {
        self.observation = observation
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        add(calendarViewController)
        setView(calendarViewController.calendarView)
        calendarViewController.calendarView.snp.remakeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(25))
            $0.left.right.bottom.equalToSuperview()
        })
        calendarViewController.calendarView.addButton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("Observe".localized)
        
        calendarViewController.onTap = onTap(_:)
        calendarViewController.onBack = onWeek
        
        viewModel.getCelendar(observation: observation)
        bind()
    }
    
    func bind() {
        viewModel.calendarItems.subscribe(onNext: { items in
            DispatchQueue.main.async {
                self.items = items
            }
        }).disposed(by: disposeBag)
    }
    
    func onWeek() {
        openGoals()
    }
    
    func onTap(_ date: Date) {
        selectedDate = date
        openGoals()
    }
    
    func openGoals() {
        let vc = ObservedGoalsViewController(observation: observation)
        vc.selectedDate = selectedDate
        navigationController?.pushViewController(vc, animated: true)
    }
}
