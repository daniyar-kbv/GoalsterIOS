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

class DayViewController: BaseViewController {
    lazy var dayView = DayView()
    lazy var viewModel = DayViewModel()
    lazy var disposeBag = DisposeBag()
    lazy var state: CalendarViewState = .notSelected
    lazy var selectedDate: Date = Date()
    lazy var tableVc = GoalsTableViewController()
    var response: GoalsResponse? {
        didSet {
            if response?.goals ?? false {
                tableVc.dayView = dayView.tableView
                tableVc.response = response
                tableVc.onReload = reload
                tableVc.viewModel.view = view
                tableVc.date = selectedDate
                add(tableVc)
                state = .goals
            } else {
                state = .noGoals
            }
            dayView.clean()
            dayView.finishSetUp(state: state)
        }
    }
    var calendarItems: [CaledarItem]? {
        didSet {
            UIView.animate(withDuration: 0, animations: {
                self.dayView.calendarCollection.reloadData()
            }, completion: { _ in
                self.dayView.calendarCollection.scrollToItem(at: IndexPath(item: self.calendarItems?.firstIndex(where: { $0.date == self.selectedDate.format() }) ?? 0, section: 0), at: .centeredHorizontally, animated: false)
            })
        }
    }
    
    override func loadView() {
        super.loadView()
        
        setView(dayView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        viewModel.view = view
        tableVc.viewModel.view = view
        
        setTitle("Calendar".localized)
        addAddButton(action: #selector(addTapped))
        
        dayView.calendarCollection.delegate = self
        dayView.calendarCollection.dataSource = self
        
        dayView.button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        dayView.monthButton.addTarget(self, action: #selector(openCalendar), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onWillEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch state {
        case .notSelected, .noGoals:
            dayView.notSelectedAnimationView.play()
        default:
            break
        }
        reload()
    }
    
    func reload() {
        if ModuleUserDefaults.getHasSpheres() {
            viewModel.getGoals(date: selectedDate)
        } else {
            dayView.finishSetUp(state: state)
        }
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
        AppShared.sharedInstance.doneGoalResponse.subscribe(onNext: { response in
            DispatchQueue.main.async {
                self.viewModel.getGoals(date: self.selectedDate, withSpinner: false)
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func addTapped() {
        if !ModuleUserDefaults.getIsLoggedIn() {
            present(AuthViewController(), animated: true, completion: nil)
        } else if !ModuleUserDefaults.getHasSpheres() {
            AppShared.sharedInstance.tabBarController.toTab(tab: 0)
        } else if let morning = response?.morning?.count, let day = response?.day?.count, let evening = response?.evening?.count, (morning + day + evening >= 6 && !ModuleUserDefaults.getIsPremium())  {
            self.present(ProfilePremiumViewController(), animated: true, completion: nil)
        } else {
            let vc = AddGoalViewController()
            vc.superVc = self
            vc.date = selectedDate
            present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func onWillEnterForegroundNotification(){
        switch state {
        case .notSelected, .noGoals:
            dayView.notSelectedAnimationView.play()
        default:
            break
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
        dayView.calendarCollection.scrollToItem(at: IndexPath(item: calendarItems?.firstIndex(where: { $0.date == selectedDate.format() }) ?? 0, section: 0), at: .centeredHorizontally, animated: true)
        viewModel.getGoals(date: date)
    }
}

extension DayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
