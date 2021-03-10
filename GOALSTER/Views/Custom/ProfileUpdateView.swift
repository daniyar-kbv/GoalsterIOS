//
//  ProfileUpdateView.swift
//  GOALSTER
//
//  Created by Dan on 2/1/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import RxSwift
import Kingfisher

class ProfileUpdateView: UIStackView {
    lazy var viewModel = UpdateProfileViewModel()
    lazy var disposeBag = DisposeBag()
    lazy var success = PublishSubject<Bool>()
    var uploadedFile: URL?
    var submitButton: CustomButton? {
        didSet {
            submitButton?.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        }
    }
    var onSuccess: (()->())?
    var email: String?
    
    enum ViewType {
        case initial
        case registration
        case update
        
        var views: [InputView.ViewType] {
            switch self {
            case .initial, .update:
                return [.nameUpdate, .specializationUpdate, .emailUpdate, .instagramUpdate, .avatarUpdate]
            case .registration:
                return [.emailRegistration, .nameRegistration, .specializationRegistration, .instagramRegistration, .avatarRegistration]
            }
        }
    }
    
    var type: ViewType
    
    required init(type: ViewType) {
        self.type = type
        
        super.init(frame: .zero)
        
        addArrangedSubViews(type.views.map({ InputView(viewType: $0) }))
        axis = .vertical
        distribution = .equalSpacing
        alignment = .fill
        spacing = StaticSize.size(15)
        
        bind()
        
        for view in (arrangedSubviews as? [InputView]) ?? [] {
            view.onChange = onChange
            view.textField.shouldReturn = shouldReturn(_:)
        }
        
        switch type {
        case .initial, .registration:
            (arrangedSubviews.first as? InputView)?.textField.becomeFirstResponder()
        case .update:
            for inputView in (arrangedSubviews as? [InputView]) ?? [] {
                let profile = AppShared.sharedInstance.profile
                switch inputView.viewType {
                case .emailUpdate:
                    inputView.textField.text = ModuleUserDefaults.getEmail()
                    inputView.textField.isEmpty = false
                case .nameUpdate:
                    inputView.textField.text = profile?.name
                    inputView.textField.isEmpty = false
                case .specializationUpdate:
                    inputView.textField.text = profile?.specialization
                    inputView.textField.isEmpty = false
                case .instagramUpdate:
                    inputView.textField.text = profile?.instagramUsername
                    inputView.textField.isEmpty = false
                case .avatarUpdate:
                    guard let url = URL(string: profile?.avatar ?? "") else { return }
                    KingfisherManager.shared.retrieveImage(with: url) { result in
                        let image = try? result.get().image
                        inputView.imageInput.selectedImage = [
                            UIImagePickerController.InfoKey.originalImage: image as Any
                        ]
                        inputView.imageInput.isEmpty = false
                    }
                default:
                    break
                }
            }
        }
    }
    
    func bind() {
        viewModel.response.subscribe(onNext: { object in
            DispatchQueue.main.async { [self] in
                self.processResponse(token: object.token, profile: object.profile, email: object.email)
            }
        }).disposed(by: disposeBag)
        viewModel.registerResponse.subscribe(onNext: { object in
            DispatchQueue.main.async {
                self.processResponse(profile: object.profile, email: object.email)
            }
        }).disposed(by: disposeBag)
    }
    
    func processResponse(token: String? = nil, profile: Profile?, email: String?) {
        if let token = token {
            ModuleUserDefaults.setToken(token)
        }
        if let email = email {
            ModuleUserDefaults.setEmail(email)
        }
        AppShared.sharedInstance.profile = profile
        self.onSuccess?()
        if let uploadedFile = uploadedFile {
            try? FileManager.default.removeItem(at: uploadedFile)
            self.uploadedFile = nil
        }
    }
    
    func shouldReturn(_ textField: UITextField) {
        guard let inputView = textField.superview as? InputView, let index = type.views.firstIndex(of: inputView.viewType) else { return }
        let nextInputView = (arrangedSubviews as? [InputView])?[index + 1]
        switch nextInputView?.inputType {
        case .text:
            nextInputView?.textField.becomeFirstResponder()
        case .image:
            guard let imagePicker = nextInputView?.imageInput.imagePicker else { return }
            endEditing(true)
            viewContainingController()?.present(imagePicker, animated: true)
        default:
            break
        }
    }
    
    func onChange(_ object: NSObject) {
        submitButton?.isActive = !(
            (arrangedSubviews as? [InputView])?.map({ $0.getInput().isEmpty }).contains(true) ?? true
        )
    }
    
    @objc func updateProfile() {
        let views = (arrangedSubviews as? [InputView])
        guard views?.first(where: { [.emailUpdate, .emailRegistration].contains($0.viewType) })?.textField.text?.isValidEmail() ?? false else {
            viewContainingController()?.showAlertOk(title: "E-mail is invalid".localized)
            return
        }
        
        switch type {
        case .registration, .initial:
            if
                let url = views?.first(where: { $0.inputType == .image })?.imageInput.selectedImage?[.imageURL] as? URL,
                let name = views?.first(where: { [.nameUpdate, .nameRegistration].contains($0.viewType) })?.textField.text,
                let specialization = views?.first(where: { [.specializationUpdate, .specializationRegistration].contains($0.viewType) })?.textField.text,
                let email = views?.first(where: { [.emailUpdate, .emailRegistration].contains($0.viewType) })?.textField.text,
                let instagramUsername = views?.first(where: { [.instagramUpdate, .instagramRegistration].contains($0.viewType) })?.textField.text
            {
                do {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    let fileName = url.lastPathComponent
                    image?.jpeg(.medium)?.saveToFile(name: fileName)
                    let imageUrl = getDocumentsDirectory().appendingPathComponent(fileName)
                    uploadedFile = imageUrl
                    self.email = email
                    switch type {
                    case .registration:
                        viewModel.register(name: name, specialization: specialization, email: email, instagramUsername: instagramUsername, avatarUrl: imageUrl)
                    case .initial:
                        viewModel.updateProfile(name: name, specialization: specialization, email: email, instagramUsername: instagramUsername, avatarUrl: imageUrl)
                    default:
                        break
                    }
                } catch {
                    print(error)
                }
            }
        case .update:
            if  let name = views?.first(where: { $0.viewType == .nameUpdate })?.textField.text,
                let specialization = views?.first(where: { $0.viewType == .specializationUpdate })?.textField.text,
                let email = views?.first(where: { $0.viewType == .emailUpdate })?.textField.text,
                let instagramUsername = views?.first(where: { $0.viewType == .instagramUpdate })?.textField.text
            {
                var imageUrl: URL? = nil
                if let url = views?.first(where: { $0.inputType == .image })?.imageInput.selectedImage?[.imageURL] as? URL {
                    do {
                        let data = try Data(contentsOf: url)
                        let image = UIImage(data: data)
                        let fileName = url.lastPathComponent
                        image?.jpeg(.medium)?.saveToFile(name: fileName)
                        imageUrl = getDocumentsDirectory().appendingPathComponent(fileName)
                        uploadedFile = imageUrl
                    } catch {
                        print(error)
                    }
                }
                self.email = email
                viewModel.updateProfile(name: name, specialization: specialization, email: email, instagramUsername: instagramUsername, avatarUrl: imageUrl)
            }
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
