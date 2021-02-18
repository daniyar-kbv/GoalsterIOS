//
//  ObservedGoalsView.swift
//  GOALSTER
//
//  Created by Daniyar on 8/20/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ObservedGoalsViewController: ProfileBaseViewController {
    lazy var dayView = DayView()
    lazy var viewModel = ObservedGoalsViewModel()
    lazy var disposeBag = DisposeBag()
    lazy var selectedDate: Date = Date()
    lazy var tableVc = GoalsTableViewController()
    var observation: Int
    var response: GoalsResponse? {
        didSet {
            tableVc.dayView = dayView.tableView
            tableVc.response = response
//            tableVc.onReload = reload
            tableVc.viewModel.view = dayView
            tableVc.date = selectedDate
            tableVc.isObserved = true
            add(tableVc)
            dayView.clean()
            dayView.finishSetUp(state: .goals)
        }
    }
    var calendarItems: [CaledarItem]? {
        didSet {
            dayView.calendarCollection.reloadData()
            dayView.layoutIfNeeded()
            dayView.calendarCollection.scrollToItem(at: IndexPath(item: calendarItems?.firstIndex(where: { $0.date == selectedDate.format() }) ?? 0, section: 0), at: .centeredHorizontally, animated: true)
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
        
        setView(dayView)
        dayView.snp.remakeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(25))
            $0.left.right.bottom.equalToSuperview()
        })
        dayView.isObserved = true
        dayView.addButton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        viewModel.view = view
        
        setTitle("Observe".localized)
        
        dayView.calendarCollection.delegate = self
        dayView.calendarCollection.dataSource = self
        
        dayView.monthButton.addTarget(self, action: #selector(openCalendar), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
    }
    
    func reload() {
        viewModel.getGoals(date: selectedDate, observation: observation)
    }
    
    func bind() {
        viewModel.response.subscribe(onNext: { response in
            DispatchQueue.main.async {
                self.response = response
            }
        }).disposed(by: disposeBag)
        viewModel.calendarItems.subscribe(onNext: { items in
            DispatchQueue.main.async {
                self.calendarItems = items
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func openCalendar() {
        navigationController?.popViewController(animated: true)
    }
    
    func chooseDate(date: Date) {
        selectedDate = date
        dayView.calendarCollection.reloadData()
        dayView.calendarCollection.scrollToItem(at: IndexPath(item: calendarItems?.firstIndex(where: { $0.date == selectedDate.format() }) ?? 0, section: 0), at: .centeredHorizontally, animated: true)
        viewModel.getGoals(date: date, observation: observation)
    }
}

extension ObservedGoalsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarSmallCell.reuseIdentifier, for: indexPath) as! CalendarSmallCell
        cell.selectedDate = selectedDate
        cell.date = calendarItems?[indexPath.row].date?.toDate()
        cell.setDots(calendarItems?[indexPath.row].goals?.first ?? false, calendarItems?[indexPath.row].goals?.second ?? false, calendarItems?[indexPath.row].goals?.third ?? false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: StaticSize.size(49), height: StaticSize.size(86))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CalendarSmallCell
        chooseDate(date: cell?.date ?? Date())
    }
}
