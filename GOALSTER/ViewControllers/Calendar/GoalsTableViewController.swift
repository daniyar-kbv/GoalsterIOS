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
    var onReload: (()->())?
    var isObserved = false
    
    var date: Date? {
        didSet {
            if let date = date {
                if date.format() == Date().format(){
                    dayView.dateLabel.attributedText = ("Today".localized + " " + "\(date.format(format: "d MMMM"))").underline(substring: "Today".localized)
                } else {
                    dayView.dateLabel.text = date.format(format: "d MMMM")
                }
            }
        }
    }
    
    var done: Bool? {
        didSet {
            if let onReload = onReload {
                onReload()
            }
        }
    }
    
    var response: GoalsResponse? {
        didSet {
            dayView.tableView.reloadData()
        }
    }
    
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
        viewModel.done.subscribe(onNext: { done in
            DispatchQueue.main.async {
                self.done = done
            }
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let dayView = view as! GoalsTableView
        if response?.goals ?? false{
            var totalHeight = dayView.tableView.frame.origin.y
            for i in 0..<3{
                for j in 0..<dayView.tableView.numberOfRows(inSection: i){
                    let cell = dayView.tableView.cellForRow(at: IndexPath(row: j, section: i))
                    totalHeight += cell?.frame.height ?? 0
                }
            }
            
            let path = CGMutablePath()
            
            let  p0 = CGPoint(x: StaticSize.size(24), y: dayView.bounds.minY)
            path.move(to: p0)

            let  p1 = CGPoint(x: StaticSize.size(24), y: totalHeight)
            path.addLine(to: p1)

            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.lightGray.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.lineDashPattern = [7, 3]

            path.addLines(between: [p0, p1])
            shapeLayer.path = path
            shapeLayer.zPosition = -1
            view.layer.addSublayer(shapeLayer)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return response?.morning?.count ?? 0 == 0 ? 0 : (response?.morning?.count ?? 0) + 1
        case 1:
            return response?.day?.count ?? 0 == 0 ? 0 : (response?.day?.count ?? 0) + 1
        case 2:
            return response?.evening?.count ?? 0 == 0 ? 0 : (response?.evening?.count ?? 0) + 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: GoalsCell.reuseIdentifier, for: indexPath) as! GoalsCell
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
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 && !isObserved{
            let cell = tableView.cellForRow(at: indexPath) as! GoalsCell
            viewModel.doneGoal(id: cell.goal?.id)
        }
    }
}
