//
//  AddVisualizationViewController.swift
//  GOALSTER
//
//  Created by Daniyar on 8/19/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Photos

class AddVisualizationViewController: UIViewController {
    lazy var addView = AddVisualizationsView()
    lazy var viewModel = AddVisualizationViewModel()
    lazy var disposeBag = DisposeBag()
    var superVc: VisualizationsMainViewcontroller?
    var uploadedFile: URL?
    
    var spheres: [SphereVisualization]? 
    
    var sphere: SphereVisualization? {
        didSet {
            guard let visualization = sphere?.visualizations?.first, let sphere = sphere else { return }
            var spheres = superVc?.spheres
            if let index = spheres?.firstIndex(where: { $0.id == sphere.id }) {
                spheres?[index].visualizations?.append(visualization)
            } else {
                spheres?.append(sphere)
            }
            superVc?.spheres = spheres?.sorted(by: { $0.id ?? 0 < $1.id ?? 0 })
            superVc?.viewWillAppear(true)
            dismiss(animated: true, completion: nil)
            if let uploadedFile = uploadedFile {
                try? FileManager.default.removeItem(at: uploadedFile)
                self.uploadedFile = nil
            }
        }
    }
    
    var selectedSphere: (SelectedSphere, Int)? {
        didSet {
            addView.setSphere(sphere: (selectedSphere?.0)!, index: (selectedSphere?.1)!)
            check()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = addView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addView.addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        (addView.mainStackView.arrangedSubviews as? [InputView])?.first(where: { $0.viewType == .sphere })?.buttonInput.addTarget(self, action: #selector(openSpheres), for: .touchUpInside)
        (addView.mainStackView.arrangedSubviews as? [InputView])?.first(where: { $0.viewType == .visualization })?.imageInput.change = { _ in
            self.check()
        }
        
        hideKeyboardWhenTappedAround()
        
        viewModel.errorView = addView
        
        bind()
    }
    
    
    
    func bind() {
        viewModel.sphere.subscribe(onNext: { sphere in
            self.sphere = sphere
        }).disposed(by: disposeBag)
    }
    
    @objc func openSpheres() {
        AppShared.sharedInstance.modalSelectedSphere = selectedSphere
        let vc = SphereModalViewController(parentVc: self)
        var show: [Int] = []
        for (index, sphere) in (spheres ?? []).enumerated()  {
            if sphere.visualizations?.count ?? 3 < 3 {
                show.append(index)
            }
        }
        vc.spheresToShow = show
        openTop(vc: vc)
//        dismiss(animated: true, completion: {
//            UIApplication.topViewController()?.present(vc, animated: true)
//        })
    }
    
    @objc func addTapped() {
        let inputViews = addView.mainStackView.arrangedSubviews as? [InputView]
        if let url = inputViews?.first(where: { $0.viewType == .visualization })?.imageInput.selectedImage?[.imageURL] as? URL {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                let fileName = url.lastPathComponent
                image?.jpeg(.lowest)?.saveToFile(name: fileName)
                let imageUrl = getDocumentsDirectory().appendingPathComponent(fileName)
                uploadedFile = imageUrl
                if let sphereIndex = selectedSphere?.1, let sphereId = spheres?[sphereIndex].id {
                    let annotationField = inputViews?.first(where: { $0.viewType == .annotation })?.textField
                    viewModel.addVisualization(
                        imageUrl: imageUrl,
                        sphere: sphereId,
                        annotation: annotationField?.isEmpty ?? true ? nil : annotationField?.text)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func check() {
        let inputViews = addView.mainStackView.arrangedSubviews as? [InputView]
        addView.addButton.isActive = selectedSphere != nil && inputViews?.first(where: { $0.viewType == .visualization })?.imageInput.selectedImage != nil
    }
}
