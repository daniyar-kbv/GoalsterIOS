//
//  GoalDetailViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/11/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class GoalDetailViewController: ProfileBaseViewController {
    lazy var mainView = GoalDetailView(goal: goal, vc: self)
    lazy var viewModel = GoalDetailViewModel()
    lazy var disposeBag = DisposeBag()
    lazy var heightSet = false
    var date: Date?
    var comments: [Comment] = [] {
        didSet {
            loadCells()
        }
    }
    var cells: [ChatCell] = [] {
        didSet {
            mainView.chatTableView.reloadData()
            mainView.chatTableView.scrollToRow(at: .init(row: cells.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    var goal: Goal {
        didSet {
            guard let goalId = goal.id else { return }
            mainView.goal = goal
            viewModel.getComments(goalId: goalId, withSpinner: false)
        }
    }
    
    required init(goal: Goal) {
        self.goal = goal
        
        super.init(nibName: .none, bundle: .none)
    }
    
    override func loadView() {
        super.loadView()
        
        setView(mainView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("Цель".localized)
        
        baseView.rightButton.setBackgroundImage(UIImage(named: "edit"), for: .normal)
        baseView.rightButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        mainView.infoButton.addTarget(self, action: #selector(infoTapped), for: .touchUpInside)
        mainView.sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        
        mainView.infoTableView.delegate = self
        mainView.infoTableView.dataSource = self
        
        AppShared.sharedInstance.navigationController.delegate = self
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.delegate = self
        AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = true
        
        mainView.chatTextView.onBegin = {
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        }
        mainView.chatTextView.onEnd = {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        }
        mainView.chatTextView.onChange = {
            self.updateHeight()
        }
        
        if goal.observer != nil, let goalId = goal.id {
            viewModel.getComments(goalId: goalId)
        }
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if goal.observer != nil {
            mainView.fakeTextField.becomeFirstResponder()
        }
    }
    
    func bind() {
        AppShared.sharedInstance.openedKeyboardSizeSubject.subscribe(onNext: { object in
            DispatchQueue.main.async {
                if !self.heightSet {
                    self.updateHeight(true)
                    self.heightSet = true
                }
            }
        }).disposed(by: disposeBag)
        viewModel.comments.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.comments = object
            }
        }).disposed(by: disposeBag)
        viewModel.commentId.subscribe(onNext: { object in
            DispatchQueue.main.async {
                var comments = self.comments
                if let index = comments.firstIndex(where: { $0.isSent == false }) {
                    comments[index].isSent = true
                }
                self.comments = comments
            }
        }).disposed(by: disposeBag)
    }
    
    func updateHeight(_ set: Bool = false) {
        let globalChatViewFrame = mainView.chatView.convert(mainView.chatView.frame, to: Global.keyWindow?.rootViewController?.view)
        let diff = ScreenSize.SCREEN_HEIGHT - (globalChatViewFrame.maxY - mainView.chatView.frame.height)
        self.mainView.chatTableView.snp.updateConstraints({
            if mainView.chatTableView.superview != nil {
                $0.bottom.equalToSuperview().offset(-diff)
            }
        })
        self.mainView.layoutIfNeeded()
        if comments.count > 0 && set {
            mainView.chatTableView.scrollToRow(at: IndexPath(row: comments.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    @objc func infoTapped() {
        mainView.infoShowed.toggle()
    }
    
    @objc func editTapped() {
        let vc = AddGoalViewController(type: .update)
        vc.goal = goal
        vc.superVc = self
        vc.date = date
        present(vc, animated: true)
    }
    
    @objc func sendTapped() {
        guard let goalId = goal.id, let text = mainView.chatTextView.text, !mainView.chatTextView.isEmpty else { return }
        mainView.chatTextView.text = ""
        mainView.chatTextView.textViewDidChange(mainView.chatTextView)
        viewModel.leaveComment(goalId: goalId, text: text)
        var comments = self.comments
        comments.append(
            Comment(
                createdAt: Date().format(format: "dd-MM-yyyy HH:mm:ss"),
                sender: User(id: nil, email: ModuleUserDefaults.getEmail()),
                text: text,
                isOwner: goal.observer?.email != ModuleUserDefaults.getEmail(),
                isRead: false,
                isSent: false
            )
        )
        self.comments = comments
    }
    
    func loadCells() {
        var cells: [ChatCell] = []
        for (index, comment) in comments.enumerated() {
            let cell = mainView.chatTableView.dequeueReusableCell(withIdentifier: ChatCell.reuseIdentifier, for: IndexPath(row: index, section: 0)) as! ChatCell
            cell.comment = comment
            cells.append(cell)
        }
        self.cells = cells
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        if goal.observer != nil, let goalId = goal.id {
            viewModel.getComments(goalId: goalId)
        }
    }
}

extension GoalDetailViewController {
    @objc override func keyboardWillShow(notification: NSNotification){
        AppShared.sharedInstance.openedKeyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
}

extension GoalDetailViewController: UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is NavigationMenuBaseController {
            AppShared.sharedInstance.navigationController.interactivePopGestureRecognizer?.isEnabled = false
            AppShared.sharedInstance.navigationController.delegate = nil
        }
    }
}

extension GoalDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GoalInfoCell.CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GoalInfoCell.reuseIdentifier, for: indexPath) as! GoalInfoCell
        cell.type = GoalInfoCell.CellType.allCases[indexPath.row]
        cell.goal = goal
        return cell
    }
}

extension GoalDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vc.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return vc.cells[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
