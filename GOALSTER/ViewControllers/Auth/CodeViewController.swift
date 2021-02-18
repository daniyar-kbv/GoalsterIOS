//
//  CodeViewController.swift
//  GOALSTER
//
//  Created by Dan on 2/3/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class CodeViewController: UIViewController {
    lazy var mainView = CodeView()
    lazy var viewModel = AuthViewModel()
    lazy var disposeBag = DisposeBag()
    private var observer: NSObjectProtocol?
    var email: String
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.suggestionView.addTarget(self, action: #selector(suggestionTapped(_:)), for: .touchUpInside)
        mainView.resendCodeButton.addTarget(self, action: #selector(resendTapped), for: .touchUpInside)
        
        bind()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            guard
                let pasteboardString = UIPasteboard.general.string,
                pasteboardString.count == 4,
                CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: pasteboardString))
            else {
                self.mainView.removeSuggestion()
                return
            }
            self.mainView.showSuggestion(code: pasteboardString)
        }
    }
    
    @objc func resendTapped() {
        viewModel.sendCode(email: email)
    }
    
    @objc func suggestionTapped(_ button: UIButton) {
        guard let pasteboardString = button.title(for: .normal) else { return }
        mainView.otpView.setCode(pasteboardString)
        mainView.removeSuggestion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.otpView.openField()
    }
    
    func bind() {
        viewModel.email.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.mainView.resendCodeButton.buttonState = .waiting
            }
        }).disposed(by: disposeBag)
        viewModel.authResponse.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }).disposed(by: disposeBag)
        mainView.otpView.code.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.viewModel.verifyOTP(email: self.email, code: object)
            }
        }).disposed(by: disposeBag)
    }
    
    @objc override func keyboardWillShow(notification: NSNotification){
        AppShared.sharedInstance.openedKeyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
    }
    
    required init(email: String) {
        self.email = email
        
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}
