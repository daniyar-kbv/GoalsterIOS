//
//  TextField.swift
//  GOALSTER
//
//  Created by Dan on 1/29/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit

protocol Input {
    var isEmpty: Bool { get set }
}

class InputView: UIStackView {
    enum InputType {
        case text
        case image
        case button
        case textView
    }
    enum ViewType {
        case emailRegistration
        case nameRegistration
        case specializationRegistration
        case instagramRegistration
        case avatarRegistration
        case emailUpdate
        case nameUpdate
        case specializationUpdate
        case instagramUpdate
        case avatarUpdate
        case timeOfTheDay
        case sphere
        case goal
        case observation
        case emotion1
        case emotion2
        case emotion3
        case emotion4
        case visualization
        case annotation
        
        var title: String {
            switch self {
            case .emailRegistration:
                return "Enter your E-mail".localized
            case .emailUpdate:
                return "E-mail"
            case .nameRegistration:
                return "Enter your name".localized
            case .nameUpdate:
                return "Name".localized
            case .specializationRegistration:
                return "Enter your specialization".localized
            case .specializationUpdate:
                return "Specialization".localized
            case .instagramRegistration:
                return "Specify your Instagram account".localized
            case .instagramUpdate:
                return "Instagram account".localized
            case .avatarRegistration:
                return "Add your own avatar".localized
            case .avatarUpdate:
                return "Avatar".localized
            case .timeOfTheDay:
                return "Choose time of day".localized
            case .sphere:
                return "Choose sphere".localized
            case .goal:
                return "Enter your goal".localized
            case .observation:
                return "Choose observer".localized
            case .emotion1:
                return "How do I feel?".localized
            case .emotion2:
                return "What will I can do better tomorrow".localized
            case .emotion3:
                return "Insight".localized
            case .emotion4:
                return "Ideas (thai came during the day)".localized
            case .visualization:
                return "Choose image".localized
            case .annotation:
                return "Add annotation (optional)".localized
            }
        }
        
        var placeholder: String {
            switch self {
            case .emailUpdate, .emailRegistration:
                return "E-mail"
            case .nameRegistration, .nameUpdate:
                return "Name".localized
            case .specializationRegistration, .specializationUpdate:
                return "Specialization placeholder".localized
            case .instagramRegistration, .instagramUpdate:
                return "@"
            case .avatarRegistration, .avatarUpdate:
                return "Avatar placeholder".localized
            case .timeOfTheDay:
                return "Time of the day".localized
            case .sphere:
                return "Sphere".localized
            case .goal:
                return "Goal".localized
            case .observation:
                return "Enter observer's E-mail".localized
            case .emotion1:
                return "Enter how dou you feel".localized
            case .emotion2:
                return "Enter what will you can do better tomorrow".localized
            case .emotion3:
                return "Enter here your insight".localized
            case .emotion4:
                return "Enter here your idea".localized
            case .visualization:
                return self.title
            case .annotation:
                return "Add annotation".localized
            }
        }
    }
    
    var viewType: ViewType
    var inputType: InputType
    var onChange: ((_ object: NSObject)->())? {
        didSet {
            switch inputType {
            case .image:
                imageInput.change = onChange
            case .text:
                textField.change = onChange
            case .button:
                buttonInput.onChange = onChange
            case .textView:
                textView?.change = onChange
            }
        }
    }
    
    private var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private var placeholder: String? {
        didSet {
            switch inputType {
            case .text:
                textField.attributedPlaceholder = NSAttributedString(
                    string: placeholder ?? "",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.strongGray]
                )
            case .image:
                imageInput.placeholder = placeholder
            case .button:
                buttonInput.title.text = placeholder
            case .textView:
                var viewTitle: String
                switch viewType {
                case .goal:
                    viewTitle = "Goal description".localized
                default:
                    viewTitle = viewType.title
                }
                textView = PrimaryTextView(placeholder: viewType.placeholder, title: viewTitle, iconImage: nil, withBorders: true, withArrow: true)
                textView?.isScrollEnabled = false
            }
        }
    }
     
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .deepBlue
        view.font = .primary(ofSize: StaticSize.size(16), weight: .bold)
        return view
    }()
    
    lazy var textField: TextField = {
        let view = TextField()
        return view
    }()
    
    lazy var imageInput: ImageInput = {
        let view = ImageInput()
        return view
    }()
    
    lazy var buttonInput: InputButton = {
        let view = InputButton()
        return view
    }()
    
    var textView: PrimaryTextView?
    
    required init(viewType: ViewType) {
        self.viewType = viewType
        
        switch viewType {
        case .avatarRegistration, .avatarUpdate, .visualization:
            inputType = .image
        case .timeOfTheDay, .sphere, .observation:
            inputType = .button
        case .goal, .emotion1, .emotion2, .emotion3, .emotion4:
            inputType = .textView
        default:
            inputType = .text
        }
        
        super.init(frame: .zero)
        
        setTitle(viewType.title)
        setPlaceholder(viewType.placeholder)
        
        addArrangedSubview(titleLabel)
        switch inputType {
        case .image:
            addArrangedSubview(imageInput)
        case .text:
            addArrangedSubview(textField)
        case .button:
            addArrangedSubview(buttonInput)
        case .textView:
            addArrangedSubview(textView!)
        }
        axis = .vertical
        distribution = .equalSpacing
        alignment = .fill
        spacing = StaticSize.size(6)
        
        switch viewType {
        case .emailUpdate, .emailRegistration:
            textField.autocapitalizationType = .none
            textField.keyboardType = .emailAddress
            textField.textContentType = .emailAddress
        case .instagramUpdate, .instagramRegistration:
            textField.autocapitalizationType = .none
        default:
            break
        }
    }
    
    func setTitle(_ string: String) {
        title = string
    }
    
    func setPlaceholder(_ string: String) {
        placeholder = string
    }
    
    func getInput() -> Input {
        switch inputType {
        case .text:
            return textField
        case .image:
            return imageInput
        case .button:
            return buttonInput
        case .textView:
            return textView!
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TextField: BaseTextField, Input {
    var isEmpty: Bool = true
    var change: ((_ object: NSObject)->())?
    var shouldReturn: ((_ textField: UITextField)->())? {
        didSet {
            shouldReturnBase = shouldReturn
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textFieldshouldChangeCharactersIn = textFieldshouldChangeCharactersIn_
        backgroundColor = .arcticWhite
        
        layer.cornerRadius = StaticSize.size(5)
        layer.borderWidth = StaticSize.size(0.5)
        layer.borderColor = UIColor.borderGray.cgColor
        addTarget(self, action: #selector(onOnchange), for: .editingChanged)
        
        snp.makeConstraints({
            $0.height.equalTo(StaticSize.fieldHeight)
        })
    }
    
    @objc func onOnchange(_ textField: UITextField) {
        isEmpty = isEmpty()
        change?(textField)
    }
    
    func textFieldshouldChangeCharactersIn_(_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool {
        guard let superview = superview as? InputView else {
            return true
        }
        switch superview.viewType {
        case .instagramUpdate, .instagramRegistration:
            guard let text = textField.text else { return true }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            switch newString.count {
            case 1:
                switch text.count {
                case 0:
                    textField.text = "@\(newString)"
                default:
                    textField.text = ""
                }
            default:
                textField.text = newString
            }
            onOnchange(textField)
            return false
        case .annotation:
            guard let text = textField.text as NSString? else { return false }
            let newText = text.replacingCharacters(in: range, with: string)
            let numberOfChars = newText.count
            return numberOfChars < 32
        default:
            return true
        }
    }
    
    let padding = UIEdgeInsets(top: 0, left: StaticSize.size(11), bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class BaseTextField: UITextField, UITextFieldDelegate {
    
    var textFieldshouldChangeCharactersIn: ((_ textField: UITextField, _ range: NSRange, _ string: String)->Bool)?
    var shouldReturnBase: ((_ textField: UITextField)->())?
    var additionalLift: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        
        addTarget(self, action: #selector(onBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(onEnd), for: .editingDidEnd)
    }
    
    @objc func onBegin() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func onEnd() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let window: UIWindow = Global.keyWindow, let superviewFrame = viewContainingController()?.view.frame, let gloabalFrame = superview?.convert(frame, to: viewContainingController()?.view), let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let diff = (superviewFrame.height - gloabalFrame.maxY) - keyboardSize.height - StaticSize.size(15)
        if diff < 0 {
            window.frame.origin.y = diff - additionalLift
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        let window: UIWindow = Global.keyWindow!
        window.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let shouldReturnBase = shouldReturnBase else {
            resignFirstResponder()
            return false
        }
        shouldReturnBase(textField)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldshouldChangeCharactersIn = textFieldshouldChangeCharactersIn else {
            return true
        }
        return textFieldshouldChangeCharactersIn(textField, range, string)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class ImageInput: UIView, UINavigationControllerDelegate, UIImagePickerControllerDelegate, Input {
    var isEmpty: Bool = true
    
    enum ImageInputState {
        case empty
        case set
    }
    
    var change: ((_ object: NSObject)->())?
    lazy var imagePicker: UIImagePickerController = {
        let view = UIImagePickerController()
        view.delegate = self
        view.sourceType = .savedPhotosAlbum
        view.allowsEditing = false
        return view
    }()
    var selectedImage: [UIImagePickerController.InfoKey : Any]? {
        didSet {
            inputState = .set
        }
    }
    var inputState: ImageInputState = .empty {
        didSet {
            switch inputState {
            case .empty:
                imageView.removeFromSuperview()
                deleteButton.removeFromSuperview()
                
                setUp()
            case .set:
                guard let image = selectedImage?[.originalImage] as? UIImage else { return }
                mainButton.removeFromSuperview()
                
                imageView.image = image
                
                addSubViews([imageView])
                imageView.snp.makeConstraints({
                    $0.left.top.bottom.equalToSuperview()
                    $0.size.equalTo(StaticSize.size(150))
                })
                
                addSubViews([deleteButton])
                deleteButton.snp.makeConstraints({
                    $0.size.equalTo(StaticSize.size(18))
                    $0.top.equalTo(imageView).offset(-StaticSize.size(4))
                    $0.right.equalTo(imageView).offset(StaticSize.size(4))
                })
            }
            isEmpty = inputState == .empty
            change?(imagePicker)
        }
    }
    var placeholder: String? {
        didSet {
            titleLabel.text = placeholder
        }
    }
    
    lazy var mainButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = StaticSize.size(5)
        view.layer.borderWidth = StaticSize.size(0.5)
        view.layer.borderColor = UIColor.borderGray.cgColor
        view.backgroundColor = .arcticWhite
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .strongGray
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.isUserInteractionEnabled = false
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var rightImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "plusGray")
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = StaticSize.size(5)
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "delete"), for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mainButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        
        setUp()
    }
    
    @objc func deleteImage() {
        inputState = .empty
        selectedImage = nil
    }
    
    @objc func selectImage() {
        PhotoLibraryPermissionManager.isPermitted() {
            if $0 && UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                DispatchQueue.main.async {
                    self.viewContainingController()?.present(self.imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func setUp() {
        addSubViews([mainButton])
        
        mainButton.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.height.equalTo(StaticSize.fieldHeight)
        })
        
        mainButton.addSubViews([rightImage, titleLabel])
        
        rightImage.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(12.5))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(StaticSize.size(11))
        })
        
        titleLabel.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(11))
            $0.right.equalTo(rightImage.snp.left).offset(-StaticSize.size(11))
            $0.centerY.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InputButton: UIButton, Input {
    var isEmpty: Bool = true
    var onChange: ((_ object: NSObject)->())?
    
    lazy var title: UILabel = {
        let view = UILabel()
        view.textColor = .strongGray
        view.font = .primary(ofSize: StaticSize.size(15), weight: .medium)
        view.isUserInteractionEnabled = false
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var leftImage: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var rightImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrowRight")
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = StaticSize.size(5)
        layer.borderWidth = StaticSize.size(0.5)
        layer.borderColor = UIColor.borderGray.cgColor
        
        snp.makeConstraints({
            $0.height.equalTo(StaticSize.fieldHeight)
        })
        
        setUp()
    }
    
    func setText(text: String, image: UIImage? = nil) {
        title.text = text
        title.textColor = .deepBlue
        
        if image != nil {
            leftImage.image = image
            
            leftImage.snp.makeConstraints({
                $0.left.equalToSuperview().offset(StaticSize.size(11))
                $0.centerY.equalToSuperview()
                $0.size.equalTo(StaticSize.size(20))
            })
            
            title.snp.remakeConstraints({
                $0.left.equalTo(leftImage.snp.right).offset(StaticSize.size(8))
                $0.right.equalTo(rightImage.snp.left).offset(-StaticSize.size(11))
                $0.centerY.equalToSuperview()
            })
        }
        
        onChange?(self)
    }
    
    func setUp() {
        addSubViews([leftImage, rightImage, title])
        
        rightImage.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-StaticSize.size(15))
            $0.centerY.equalToSuperview()
            $0.height.equalTo(StaticSize.size(10.5))
            $0.width.equalTo(StaticSize.size(6))
        })
        
        title.snp.makeConstraints({
            $0.left.equalToSuperview().offset(StaticSize.size(11))
            $0.right.equalTo(rightImage.snp.left).offset(-StaticSize.size(11))
            $0.centerY.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


