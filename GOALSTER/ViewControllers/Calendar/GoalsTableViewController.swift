//
//  GoalsTableViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/17/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class GoalsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dayView: GoalsTableView!
    lazy var viewModel = GoalsTableViewModel()
    lazy var disposeBag = DisposeBag()
    var type: VcType = .regular
    var user: FeedUserFull?
    var isObserved = false
    var openGoal: Int?
    var onReload: (()->())?
    var date: Date? {
        didSet {
        }
    }
    
    var response: GoalsResponse? {
        didSet {
            self.dayView.tableView.reloadData()
            
            if let goalId = openGoal,
               let section = (0..<dayView.tableView.numberOfSections).first(where: { section in
                    (0..<dayView.tableView.numberOfRows(inSection: section)).contains(where: { row in
                        (dayView.tableView.cellForRow(at: IndexPath(row: row, section: section)) as? GoalsCell)?.goal?.id == goalId
                    })
                }),
               let row = (0..<dayView.tableView.numberOfRows(inSection: section)).first(where: { row in
                    (dayView.tableView.cellForRow(at: IndexPath(row: row, section: section)) as? GoalsCell)?.goal?.id == goalId
               }) {
                tableView(dayView.tableView, didSelectRowAt: IndexPath(row: row, section: section))
                openGoal = nil
            }
        }
    }
    
    var line: CAShapeLayer?
    
    override func loadView() {
        super.loadView()
        
        view = dayView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayView.tableView.delegate = self
        dayView.tableView.dataSource = self
        
        bind()
    }
    
    func bind() {
//        viewModel.done.subscribe(onNext: { object in
//            DispatchQueue.main.async {
//                self.onReload?()
//            }
//        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let dayView = view as! GoalsTableView
        if response?.goals ?? false{
            var minY: CGFloat = 0
            var totalHeight = dayView.tableView.frame.origin.y
            for i in 0..<dayView.tableView.numberOfSections{
                for j in 0..<dayView.tableView.numberOfRows(inSection: i){
                    let cell = dayView.tableView.cellForRow(at: IndexPath(row: j, section: i))
                    if !(cell is GoalsReactionsCell) {
                        if i == 0 && j == 0, let y = cell?.frame.minY {
                            minY = y
                        }
//                    if !(type == .feed && 1 == dayView.tableView.numberOfSections - 1) && !(i == dayView.tableView.numberOfSections - 1 && j == dayView.tableView.numberOfRows(inSection: dayView.tableView.numberOfSections - 1) - 1) {
                        totalHeight += cell?.frame.height ?? 0
                    }
                }
            }

            let path = CGMutablePath()

            let  p0 = CGPoint(x: StaticSize.size(16), y: minY)
            path.move(to: p0)

            let  p1 = CGPoint(x: StaticSize.size(16), y: totalHeight)
            path.addLine(to: p1)

            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.lightGray.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.lineDashPattern = [7, 3]

            path.addLines(between: [p0, p1])
            shapeLayer.path = path
            shapeLayer.zPosition = -1
            print(totalHeight)
            line?.removeFromSuperlayer()
            dayView.layer.addSublayer(shapeLayer)
            line = shapeLayer
        }
    }
    
    func doneButtonTapped(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard type == .regular else { return }
        if indexPath.row != 0 && !isObserved {
            let cell = tableView.cellForRow(at: indexPath) as! GoalsCell
            viewModel.doneGoal(id: cell.goal?.id)
            let newGoal = cell.goal
            newGoal?.isDone = !(cell.goal?.isDone ?? false)
            cell.goal = newGoal
            let totalGoals = AppShared.sharedInstance.totalGoals
            switch cell.goal?.sphere {
            case .first:
                totalGoals?.first = cell.goal?.isDone ?? false ?
                    (totalGoals?.first ?? 0) + 1 :
                    (totalGoals?.first ?? 0) - 1
            case .second:
                totalGoals?.second = cell.goal?.isDone ?? false ?
                    (totalGoals?.second ?? 0) + 1 :
                    (totalGoals?.second ?? 0) - 1
            case .third:
                totalGoals?.third = cell.goal?.isDone ?? false ?
                    (totalGoals?.third ?? 0) + 1 :
                    (totalGoals?.third ?? 0) - 1
            default:
                break
            }
            AppShared.sharedInstance.totalGoals = totalGoals
            if date?.format() == Date().format() {
                let goalsStatus = AppShared.sharedInstance.goalsStatus
                switch cell.goal?.time {
                case .morning:
                    goalsStatus?.goals?.goals?.morning?.first(where: { $0.id == cell.goal?.id })?.isDone = cell.goal?.isDone
                case .day:
                    goalsStatus?.goals?.goals?.day?.first(where: { $0.id == cell.goal?.id })?.isDone = cell.goal?.isDone
                case .evening:
                    goalsStatus?.goals?.goals?.evening?.first(where: { $0.id == cell.goal?.id })?.isDone = cell.goal?.isDone
                default:
                    break
                }
                AppShared.sharedInstance.goalsStatus = goalsStatus
            }
            if !(viewModel.view is DayView) {
                let localCalendar = AppShared.sharedInstance.localCalendar
                switch cell.goal?.time {
                case .morning:
                    localCalendar?.first(where: { $0.calendarItem?.date == date?.format() })?.goalsResponse?.morning?.first(where: { $0.id == cell.goal?.id })?.isDone = cell.goal?.isDone
                case .day:
                    localCalendar?.first(where: { $0.calendarItem?.date == date?.format() })?.goalsResponse?.day?.first(where: { $0.id == cell.goal?.id })?.isDone = cell.goal?.isDone
                case .evening:
                    localCalendar?.first(where: { $0.calendarItem?.date == date?.format() })?.goalsResponse?.evening?.first(where: { $0.id == cell.goal?.id })?.isDone = cell.goal?.isDone
                default:
                    break
                }
                AppShared.sharedInstance.localCalendar = localCalendar
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch type {
        case .regular:
            return 3
        case .feed:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return response?.morning?.count ?? 0 == 0 ? 0 : (response?.morning?.count ?? 0) + 2
        case 1:
            return response?.day?.count ?? 0 == 0 ? 0 : (response?.day?.count ?? 0) + 2
        case 2:
            return response?.evening?.count ?? 0 == 0 ? 0 : (response?.evening?.count ?? 0) + 2
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: GoalsReactionsCell.reuseIdentifier, for: indexPath) as! GoalsReactionsCell
            cell.user = user
            return cell
        default:
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: GoalsHeaderCell.reuseIdentifier, for: indexPath) as! GoalsHeaderCell
                switch indexPath.section {
                case 0:
                    cell.time = .morning
                case 1:
                    cell.time = .day
                case 2:
                    cell.time = .evening
                default:
                    break
                }
                return cell
            } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                let cell = UITableViewCell()
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.contentView.snp.makeConstraints({
                    $0.height.equalTo(StaticSize.size(11))
                })
                return cell
            } else {
                let cell = GoalsCell()
                switch indexPath.section {
                case 0:
                    cell.goal = response?.morning?[indexPath.row - 1]
                case 1:
                    cell.goal = response?.day?[indexPath.row - 1]
                case 2:
                    cell.goal = response?.evening?[indexPath.row - 1]
                default:
                    break
                }
                cell.indexPath = indexPath
                cell.onDone = {
                    self.doneButtonTapped(self.dayView.tableView, didSelectRowAt: $0)
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let goal = (tableView.cellForRow(at: indexPath) as? GoalsCell)?.goal, type == .regular else { return }
        let vc = GoalDetailViewController(goal: goal)
        vc.date = date
        vc.baseView.rightButton.isHidden = isObserved
        AppShared.sharedInstance.navigationController.pushViewController(vc, animated: true)
    }
    
    enum VcType {
        case regular
        case feed
    }
}
