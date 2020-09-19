//
//  ResultsViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 9/2/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class ResultsViewController: UIViewController {
    lazy var resultsView = ResultsView()
    lazy var viewModel = ResultsViewModel()
    lazy var disposeBag = DisposeBag()
    
    var results: [Result]? {
        didSet {
            for (index, result) in (results ?? []).enumerated() {
                let resultView: ResultSmallView = {
                    let view = ResultSmallView()
                    view.result = result
                    view.index = index
                    return view
                }()
                
                resultsView.stack.addArrangedSubview(resultView)
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = resultsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        viewModel.getResults()
        
        resultsView.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func bind() {
        viewModel.results.subscribe(onNext: { results in
            DispatchQueue.main.async {
                self.results = results
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func buttonTapped() {
        dismiss(animated: true, completion: {
            let vc = UIApplication.topViewController()
            vc?.present(SpheresListViewController(), animated: true, completion: nil)
        })
    }
}
