//
//  TextFieldViewController.swift
//  GOALSTER
//
//  Created by Dan on 1/28/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class TextFieldViewController: ChildViewController {
    lazy var mainView = TextFieldView(iconImage: iconImage)
    lazy var disposeBag = DisposeBag()
    var textView: PrimaryTextView
    var iconImage: UIImage?
    var onChange: ((_ textView: UITextView)->())?
    
    required init(textView: PrimaryTextView, iconImage: UIImage? = nil, parentVc: UIViewController) {
        self.textView = textView
        self.iconImage = iconImage
        
        super.init(parentVc: parentVc)
        
        mainView.textView.text = textView.text
        mainView.textView.isEmpty = textView.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(parentVc: UIViewController) {
        fatalError("init(parentVc:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        bind()
        
        mainView.nextButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        mainView.backButton.onBack = close
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func saveTapped() {
        textView.text = mainView.textView.text
        textView.isEmpty = mainView.textView.isEmpty
        onChange?(textView)
        close()
    }
    
    func close() {
        textView.resignFirstResponder()
        removeTop()
    }
    
    func bind() {
        AppShared.sharedInstance.openedKeyboardSizeSubject.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.mainView.textView.snp.updateConstraints({
                    $0.bottom.equalToSuperview().offset(-(object.height))
                })
                UIView.animate(withDuration: 0.2, animations: {
                    self.mainView.layoutIfNeeded()
                })
            }
        }).disposed(by: disposeBag)
    }
    
    @objc override func keyboardWillShow(notification: NSNotification){
        AppShared.sharedInstance.openedKeyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
}
