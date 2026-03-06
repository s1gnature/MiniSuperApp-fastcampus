//
//  AddPaymentMethodViewController.swift
//  MiniSuperApp
//
//  Created by mong on 8/9/25.
//

import ModernRIBs
import UIKit

protocol AddPaymentMethodPresentableListener: AnyObject {
    
    func didTapClose()
    func didTapConfirm(number: String, cvc: String, expiry: String)
}

final class AddPaymentMethodViewController: UIViewController, AddPaymentMethodPresentable, AddPaymentMethodViewControllable {

    weak var listener: AddPaymentMethodPresentableListener?
    
    private let cardNumberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.placeholder = "카드 번호"
        return textField
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 14
        return stackView
    }()
    private let securityTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.placeholder = "CVC"
        return textField
    }()
    private let expirationTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.placeholder = "유효기간"
        return textField
    }()
    private lazy var addCardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCorners()
        button.backgroundColor = .primaryRed
        button.setTitle("추가하기", for: .normal)
        button.addTarget(self, action: #selector(didTapAddCard), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        title = "카드 추가"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(didTapClose)
        )
        view.backgroundColor = .white
        [
            cardNumberTextField,
            stackView,
            addCardButton
        ].forEach { view.addSubview($0) }
        
        [
            securityTextField,
            expirationTextField
        ].forEach { stackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            cardNumberTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            cardNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cardNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            stackView.topAnchor.constraint(equalTo: cardNumberTextField.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            addCardButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            cardNumberTextField.heightAnchor.constraint(equalToConstant: 60),
            securityTextField.heightAnchor.constraint(equalToConstant: 60),
            expirationTextField.heightAnchor.constraint(equalToConstant: 60),
            addCardButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc
    private func didTapAddCard() {
        if let number = cardNumberTextField.text,
           let cvc = securityTextField.text,
           let expiry = expirationTextField.text {
            listener?.didTapConfirm(number: number, cvc: cvc, expiry: expiry)
        }
    }
    
    @objc
    private func didTapClose() {
        listener?.didTapClose()
    }
}
