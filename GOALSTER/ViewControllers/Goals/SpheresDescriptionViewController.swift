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
    lazy var spheresView = SpheresDescriptionView(spheres: spheres, fromProfile: fromProfile)
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = ChooseSpheresViewModel()
    
    var spheres: [(key: Sphere, value: String)]
    var fromProfile: Bool
    
    required init(spheres: [(key: Sphere, value: String)], fromProfile: Bool = false) {
        self.spheres = spheres
        self.fromProfile = fromProfile
        
        super.init(nibName: .none, bundle: .none)
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
        
        for (index, view) in ((spheresView.mainStackView.arrangedSubviews as? [SpheresDescriptionSmallView]) ?? []).enumerated() {
            view.textView.onChange = fieldChanged(_:)
            if fromProfile {
                view.textView.text = ModuleUserDefaults.getSpheres()?[index].description_
                view.textView.textColor = .ultraGray
                view.textView.isEmpty = false
            }
        }
        
        spheresView.nextButton.isActive = !fromProfile
        spheresView.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        bind()
    }
    
    func bind() {
        viewModel.spheres.subscribe(onNext: { spheres in
            DispatchQueue.main.async {
                AppShared.sharedInstance.selectedSpheres = spheres
                ModuleUserDefaults.setSpheres(object: spheres)
                AppShared.sharedInstance.hasSpheres = true
                ModuleUserDefaults.setHasSpheres(true)
                if self.parent != nil {
                    self.parent?.dismiss(animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func fieldChanged(_ textView: UITextView){
        spheresView.nextButton.isActive = !((spheresView.mainStackView.arrangedSubviews as? [SpheresDescriptionSmallView])?.map({ $0.textView.textColor }).contains(.lightGray) ?? true)
    }
    
    @objc func nextTapped() {
        if fromProfile {
            guard let views = spheresView.mainStackView.arrangedSubviews as? [SpheresDescriptionSmallView] else { return }
            viewModel.updateSpheres(firstDescription: views[0].textView.text, secondDescription: views[1].textView.text, thirdDescription: views[2].textView.text)
        } else {
            var spheres_: [(key: String, value: String)] = []
            for view in spheresView.mainStackView.arrangedSubviews as! [SpheresDescriptionSmallView] {
                spheres_.append((key: spheres[view.index ?? 0].value, value: view.textView.text))
            }
            if spheres_.count == 3 {
                viewModel.chooseSpheres(spheres: spheres_)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
