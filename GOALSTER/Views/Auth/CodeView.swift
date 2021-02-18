//
//  CodeView.swift
//  GOALSTER
//
//  Created by Dan on 2/3/21.
//  Copyright © 2021 MTI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class CodeView: View {
    lazy var otpView: OTPView = {
        let view = OTPView()
        return view
    }()
    
    lazy var suggestionView: CustomButton = {
        let view = CustomButton()
        view.layer.cornerRadius = StaticSize.buttonHeight / 2
        view.snp.makeConstraints({
            $0.width.equalTo(ScreenSize.SCREEN_WIDTH / 3)
            $0.height.equalTo(StaticSize.buttonHeight)
        })
        view.isActive = false
        return view
    }()
    
    lazy var resendCodeButton: ResendCodeButton = {
        let view = ResendCodeButton()
        return view
    }()
    
    required init() {
        super.init()
        
        title = "Sign in".localized
        subtitle = "Enter code".localized
        
        setUp()
    }
    
    func setUp() {
        contentView.addSubViews([otpView, resendCodeButton])
        
        otpView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(StaticSize.size(45))
            $0.left.equalToSuperview().offset(StaticSize.size(15))
        })
        
        resendCodeButton.snp.makeConstraints({
            $0.top.equalTo(otpView.snp.bottom).offset(StaticSize.size(15))
            $0.left.equalToSuperview().offset(StaticSize.size(15))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(withBackButton: Bool = false, iconImage: UIImage? = nil) {
        fatalError("init(withBackButton:iconImage:) has not been implemented")
    }
    
    func showSuggestion(code: String) {
        suggestionView.setTitle(code, for: .normal)
        if !suggestionView.isActive {
            suggestionView.isActive = true
            
            contentView.addSubview(suggestionView)
            
            suggestionView.snp.makeConstraints({
                $0.bottom.equalToSuperview().offset(StaticSize.buttonHeight)
                $0.centerX.equalToSuperview()
            })
            
            layoutIfNeeded()
            
            suggestionView.snp.updateConstraints({
                $0.bottom.equalToSuperview().offset(-(StaticSize.size(15) +  (AppShared.sharedInstance.openedKeyboardSize?.height ?? 0)))
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
            })
        }
    }
    
    func removeSuggestion() {
        if suggestionView.isActive {
            suggestionView.isActive = false
        
            suggestionView.snp.updateConstraints({
                $0.bottom.equalToSuperview().offset(StaticSize.buttonHeight)
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
            }, completion: { finished in
                if finished {
                    self.suggestionView.removeFromSuperview()
                }
            })
        }
    }
}

class OTPView: UIStackView, UITextFieldDelegate {
    lazy var fields: [CodeField] = []
    lazy var code = PublishSubject<String>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        for i in 0..<4 {
            let field = CodeField()
            field.field.delegate = self
            field.field.tag = i
            fields.append(field)
        }
        
        addArrangedSubViews(fields)
        
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .fill
        spacing = StaticSize.size(12)
    }
    
    func openField() {
        fields.first?.field.becomeFirstResponder()
    }
    
    func setCode(_ code: String? = nil) {
        if let code = code {
            for (index, char) in Array(code).enumerated() {
                fields[index].field.text = String(char)
            }
        }
        let otp = fields.map({ $0.field.text ?? "" }).joined(separator: "")
        guard otp.count == 4 else { return }
        endEditing(true)
        self.code.onNext(otp)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else { return false }
        if string.count == 4 {
            setCode(string)
        } else {
            let forward = string != ""
            if forward {
                if textField.text == "\u{200B}" {
                    textField.text = string
                } else if textField.tag < 3 {
                    fields[textField.tag + 1].field.text = string
                }
            } else {
                if textField.text == "\u{200B}" && textField.tag > 0 {
                    fields[textField.tag - 1].field.text = "\u{200B}"
                } else {
                    textField.text = "\u{200B}"
                }
            }
            switch textField.tag {
            case 0:
                if forward {
                    fields[textField.tag + 1].field.becomeFirstResponder()
                }
            case 1, 2:
                fields[forward ? textField.tag + 1 : textField.tag - 1].field.becomeFirstResponder()
            case 3:
                if !forward {
                    fields[textField.tag - 1].field.becomeFirstResponder()
                }
            default:
                break
            }
            if !fields.map({ $0.field.text != "\u{200B}" }).contains(false) {
                setCode()
            }
        }
        return false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CodeField: UIView {
    lazy var field: UITextField = {
        let view = UITextField()
        view.font = .primary(ofSize: StaticSize.size(50), weight: .bold)
        view.textColor = .deepBlue
        view.keyboardType = .numberPad
        view.textContentType = .oneTimeCode
        view.text = "\u{200B}"
        return view
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .borderGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        snp.makeConstraints({
            $0.width.equalTo(StaticSize.size(39))
            $0.height.equalTo(StaticSize.size(50))
        })
        
        setUp()
    }
    
    func setUp() {
        addSubViews([field, bottomLine])
        
        field.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        })
        
        bottomLine.snp.makeConstraints({
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(StaticSize.size(2))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ResendCodeButton: UIButton {
    enum State {
        case waiting
        case active
    }
    
    var initialTime: Double = 300
    var timer: Timer?
    var timerValue: Double! {
        didSet {
            guard let timerValue = timerValue else { return }
            setTitle("\("Resend code within".localized) - \(Int(timerValue).toTime())", for: .normal)
        }
    }
    var buttonState: State = .waiting {
        didSet {
            switch buttonState {
            case .waiting:
                setTitleColor(.strongGray, for: .normal)
                isUserInteractionEnabled = false
                runTimer()
            case .active:
                setTitleColor(.middleBlue, for: .normal)
                isUserInteractionEnabled = true
                setTitle("Resend code".localized, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = .primary(ofSize: StaticSize.size(15), weight: .regular)
        setTitleColor(.strongGray, for: .normal)
        
        runTimer()
    }
    
    func runTimer() {
        timer?.invalidate()
        timerValue = initialTime
        setTitle("\("Resend code within".localized) - \(Int(initialTime).toTime())", for: .normal)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerValue -= 1
            if self.timerValue == 0{
                self.timer?.invalidate()
                self.buttonState = .active
                return
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
