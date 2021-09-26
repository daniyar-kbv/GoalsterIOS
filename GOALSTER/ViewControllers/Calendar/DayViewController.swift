//
//  DayViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/15/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class DayViewController: UIViewController {
    lazy var dayView = DayView()
    lazy var viewModel = DayViewModel()
    lazy var disposeBag = DisposeBag()
    lazy var selectedDate: Date = Date() {
        didSet {
            dayView.dateLabel.text = selectedDate.format() == Date().format() ?
                "Today".localized + " " + "\(selectedDate.format(format: "d MMMM"))" :
                selectedDate.format(format: "d MMMM")
        }
    }
    lazy var tableVc: GoalsTableViewController = {
        let view = GoalsTableViewController()
        view.dayView = dayView.tableView
        view.onReload = reload
        view.viewModel.view = self.view
        add(view)
        return view
    }()
    lazy var state: CalendarViewState = .notSelected {
        didSet {
            dayView.clean()
            dayView.finishSetUp(state: state)
        }
    }
    var response: GoalsResponse? {
        didSet {
            if response?.goals ?? false {
                tableVc.response = response
                tableVc.date = selectedDate
                state = .goals
            } else {
                state = .noGoals
            }
        }
    }
    var calendarItems: [CaledarItem] = (0..<7).map({ CaledarItem(date: Calendar.current.date(byAdding: DateComponents(day: $0), to: Date())?.format(), goals: nil) }) {
        didSet {
            UIView.animate(withDuration: 0, animations: {
                self.dayView.calendarCollection.reloadData()
            }, completion: { _ in
//                self.dayView.calendarCollection.scrollToItem(at: IndexPath(item: self.calendarItems.firstIndex(where: { $0.date == self.selectedDate.format() }) ?? 0, section: 0), at: .centeredHorizontally, animated: false)
            })
            if AppShared.sharedInstance.localCalendar != nil && calendarItems.count > 7 {
                for i in 0..<(AppShared.sharedInstance.localCalendar ?? []).count {
                    AppShared.sharedInstance.localCalendar?[i].calendarItem = calendarItems[i]
                }
                ModuleUserDefaults.setLocalCalendar(object: AppShared.sharedInstance.localCalendar)
            } else {
                AppShared.sharedInstance.localCalendar = calendarItems.map({
                    LocalCalendarItem(calendarItem: $0, goalsResponse: nil)
                })
            }
        }
    }
    lazy var didAppear = false
    
    override func loadView() {
        super.loadView()
        
        view = dayView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        viewModel.view = view
        viewModel.vc = self
        tableVc.viewModel.view = view
        
        dayView.addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        dayView.calendarCollection.delegate = self
        dayView.calendarCollection.dataSource = self
        
        dayView.button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        dayView.monthButton.addTarget(self, action: #selector(openCalendar), for: .touchUpInside)
        
        if !ModuleUserDefaults.getIsLoggedIn() || !ModuleUserDefaults.getHasSpheres() {
            state = .notSelected
        } else if ModuleUserDefaults.getHasSpheres() {
            if let localCalendar = AppShared.sharedInstance.localCalendar {
                calendarItems = localCalendar.map({ $0.calendarItem ?? CaledarItem(date: nil, goals: nil) })
                if let response = localCalendar.first(where: { $0.calendarItem?.date == selectedDate.format() })?.goalsResponse {
                    self.response = response
                    viewModel.getGoals(date: selectedDate, withSpinner: false)
                } else {
                    viewModel.getGoalsOnly(date: selectedDate, withSpinner: true)
                }
            } else {
                viewModel.getGoals(date: selectedDate, withSpinner: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if didAppear && ModuleUserDefaults.getIsLoggedIn() {
            viewModel.getGoals(date: selectedDate, withSpinner: false)
        } else {
            didAppear = true
        }
    }
    
    func reload() {
        viewModel.getGoals(date: selectedDate, withSpinner: false)
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
        AppShared.sharedInstance.localCalendarSubject.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.calendarItems = object.map({ $0.calendarItem ?? CaledarItem(date: nil, goals: nil) })
                if let selectedLocalDate = object.first(where: { $0.calendarItem?.date == self.selectedDate.format() })?.calendarItem?.date?.toDate(),
                   let selectedLocalResponse = object.first(where: { $0.calendarItem?.date == self.selectedDate.format() })?.goalsResponse {
                    self.setResponse(date: selectedLocalDate, response: selectedLocalResponse)
                }
            }
        }).disposed(by: disposeBag)
        AppShared.sharedInstance.isLoggedInSubject.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.viewWillAppear(true)
            }
        }).disposed(by: disposeBag)
    }
    
    func setResponse(date: Date, response: GoalsResponse) {
        if date.format() == selectedDate.format() {
            self.response = response
        }
        AppShared.sharedInstance.localCalendar?.first(where: {
            $0.calendarItem?.date == selectedDate.format()
        })?.goalsResponse = response
        ModuleUserDefaults.setLocalCalendar(object: AppShared.sharedInstance.localCalendar)
    }
    
    @objc func addTapped() {
        if !ModuleUserDefaults.getIsLoggedIn() {
            present(FirstAuthViewController(), animated: true, completion: nil)
        } else if !ModuleUserDefaults.getHasSpheres() {
            AppShared.sharedInstance.tabBarController.toTab(tab: 1)
        } else if let morning = response?.morning?.count, let day = response?.day?.count, let evening = response?.evening?.count, (morning + day + evening >= 6 && !ModuleUserDefaults.getIsPremium())  {
            let premiumVC = PayBallController()
            premiumVC.onBack = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            premiumVC.onSuccess = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                self?.addTapped()
            }
            premiumVC.hideTopBrush()
            navigationController?.pushViewController(premiumVC, animated: true)
        } else {
            let vc = AddGoalViewController()
            vc.superVc = self
            vc.date = selectedDate
            present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func openCalendar() {
        let vc = CalendarViewController()
        vc.items = calendarItems
        vc.superVc = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func chooseDate(date: Date) {
        selectedDate = date
        dayView.calendarCollection.reloadData()
        dayView.calendarCollection.scrollToItem(at: IndexPath(item: calendarItems.firstIndex(where: { $0.date == selectedDate.format() }) ?? 0, section: 0), at: .centeredHorizontally, animated: true)
        if ModuleUserDefaults.getIsLoggedIn() {
            if let response = AppShared.sharedInstance.localCalendar?.first(where: { $0.calendarItem?.date == selectedDate.format() })?.goalsResponse {
                self.response = response
                viewModel.getGoalsOnly(date: selectedDate, withSpinner: false)
            } else {
                viewModel.getGoalsOnly(date: selectedDate)
            }   
        }
    }
}

extension DayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarSmallCell.reuseIdentifier, for: indexPath) as! CalendarSmallCell
        cell.selectedDate = selectedDate
        cell.date = calendarItems[indexPath.row].date?.toDate()
        cell.setDots(calendarItems[indexPath.row].goals?.first ?? false, calendarItems[indexPath.row].goals?.second ?? false, calendarItems[indexPath.row].goals?.third ?? false)
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
