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

class AddVisualizationViewController: UIViewController {
    lazy var addView = AddVisualizationsView()
    lazy var imagePicker = UIImagePickerController()
    lazy var viewModel = AddVisualizationViewModel()
    lazy var disposeBag = DisposeBag()
    var superVc: VisualizationsMainViewcontroller?
    
    var spheres: [SphereVisualization]? 
    
    var success: Bool? {
        didSet {
            superVc?.reload()
            dismiss(animated: true, completion: nil)
        }
    }
    
    var selectedImage: [UIImagePickerController.InfoKey : Any]? {
        didSet {
            addView.secondBottom.isHidden = true
            addView.secondContainer.snp.makeConstraints({
                $0.size.equalTo(StaticSize.size(200)).priority(.high)
            })
            addView.imageView.image = selectedImage?[.originalImage] as! UIImage
            addView.imageView.isHidden = false
            check()
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
        
        addView.firstBottom.addTarget(self, action: #selector(openSpheresModal), for: .touchUpInside)
        addView.secondBottom.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        addView.addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        addView.backButton.addTarget(self, action: #selector(dismissAnimated), for: .touchUpInside)
        addView.onFieldChange = check
        
        hideKeyboardWhenTappedAround()
        
        bind()
    }
    
    func bind() {
        viewModel.success.subscribe(onNext: { success in
            self.success = success
        }).disposed(by: disposeBag)
    }
    
    @objc func openSpheresModal(){
        let vc = SphereModalViewController(modalHeight: ScreenSize.SCREEN_HEIGHT / 3)
        var show: [Int] = []
        for (index, sphere) in (spheres ?? []).enumerated()  {
            if sphere.visualizations?.count ?? 3 < 3 {
                show.append(index)
            }
        }
        vc.spheresToShow = show
        openModal(vc: vc)
    }
    
    @objc func addTapped() {
        if let imageURL = selectedImage?[.imageURL] as? URL, let sphereIndex = selectedSphere?.1, let sphereId = spheres?[sphereIndex].id {
            viewModel.addVisualization(imageUrl: imageURL, sphere: sphereId, annotation: addView.thirdBottom.textColor == .lightGray ? nil : addView.thirdBottom.text)
        }
    }
    
    @objc func selectImage() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = false

                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func check() {
        addView.addButton.isActive = selectedSphere != nil && selectedImage != nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disableKeyboardDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardDisplay()
    }
}

extension AddVisualizationViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info
        dismiss(animated: true, completion: nil)
    }
}

extension AddVisualizationViewController {
    @objc override func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            AppShared.sharedInstance.openedKeyboardSize = keyboardSize
        }
        
    }
    
    @objc override func keyboardWillHide(notification: NSNotification){
    }
}
