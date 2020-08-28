//
//  SpheresDescriptionViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/12/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SpheresDescriptionViewController: UIViewController {
    lazy var spheresView = SpheresDescriptionView()
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = ChooseSpheresViewModel()
    lazy var fromProfile = false
    
    var spheres: [(key: Sphere, value: String)]? {
        didSet {
            spheresView.firstView.sphere = spheres?[0]
            spheresView.secondView.sphere = spheres?[1]
            spheresView.thirdView.sphere = spheres?[2]
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = spheresView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spheresView.backButton.onBack = {
            self.removeTop()
        }
        
        spheresView.firstView.onChange = fieldChanged(_:)
        spheresView.secondView.onChange = fieldChanged(_:)
        spheresView.thirdView.onChange = fieldChanged(_:)
        
        spheresView.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disableKeyboardDisplay()
        parent?.keyboardDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        parent?.disableKeyboardDisplay()
        keyboardDisplay()
    }
    
    func bind() {
        viewModel.spheres.subscribe(onNext: { spheres in
            DispatchQueue.main.async {
                AppShared.sharedInstance.selectedSpheres = spheres
                ModuleUserDefaults.setSpheres(value: spheres)
                AppShared.sharedInstance.hasSpheres = true
                ModuleUserDefaults.setHasSpheres(true)
                if !self.fromProfile {
                    self.parent?.dismiss(animated: true, completion: nil)
                } else {
                    self.openTop(vc: SpheresSuccessViewController())
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func fieldChanged(_ textView: UITextView){
        spheresView.nextButton.isActive = spheresView.firstView.textView.textColor != .lightGray && spheresView.secondView.textView.textColor != .lightGray && spheresView.thirdView.textView.textColor != .lightGray
    }
    
    @objc func nextTapped() {
        var spheres_: [(key: String, value: String)] = []
        for view in spheresView.mainStackView.arrangedSubviews as! [SpheresDescriptionSmallView] {
            if let sphereName = spheres?[view.index ?? 0].value{
                spheres_.append((key: sphereName, value: view.textView.text))
            }
        }
        if spheres_.count == 3 {
            viewModel.chooseSpheres(spheres: spheres_)
        }
    }
}

extension SpheresDescriptionViewController {
    @objc override func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            AppShared.sharedInstance.openedKeyboardSize = keyboardSize
        }
        
    }
    
    @objc override func keyboardWillHide(notification: NSNotification){
    }
}
