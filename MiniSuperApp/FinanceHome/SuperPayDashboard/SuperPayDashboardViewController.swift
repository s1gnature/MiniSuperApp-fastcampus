//
//  SuperPayDashboardViewController.swift
//  MiniSuperApp
//
//  Created by narr on 5/6/24.
//

import ModernRIBs
import UIKit

protocol SuperPayDashboardPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func chargeBalance(amount: Double)
    func topupButtonDidTap()
}

final class SuperPayDashboardViewController: UIViewController, SuperPayDashboardPresentable, SuperPayDashboardViewControllable {

    // MARK: - Views

    private let titleStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        return sv
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "슈퍼페이 잔고"
        return label
    }()
    private lazy var titleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("충전하기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(topupButtonDidtap), for: .touchUpInside)
        return button
    }()
    private let cardContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .magenta
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        return view
    }()
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "원"
        label.textColor = .white
        return label
    }()
    private let balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .white
        return label
    }()
    private let balanceStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        sv.axis = .horizontal
        sv.spacing = 4
        return sv
    }()

    weak var listener: SuperPayDashboardPresentableListener?

    init() {
        super.init(nibName: nil, bundle: nil)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    private func configureUI() {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - Hierarchy

        [
            titleStackView,
            cardContainerView,
        ].forEach { view.addSubview($0) }
        
        [
            titleLabel,
            titleButton
        ].forEach { titleStackView.addArrangedSubview($0) }

        [
            balanceAmountLabel,
            currencyLabel
        ].forEach { balanceStackView.addArrangedSubview($0) }

        [
            balanceStackView
        ].forEach { cardContainerView.addSubview($0) }


        // MARK: - Constraints

        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            cardContainerView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 10),
            cardContainerView.heightAnchor.constraint(equalToConstant: 180),
            cardContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),

            balanceStackView.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor),
            balanceStackView.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor),
        ])
    }

    // MARK: - Private

    func updateBalance(_ balanceString: String) {
        balanceAmountLabel.text = balanceString
    }
    
    @objc
    private func topupButtonDidtap() {
        listener?.topupButtonDidTap()
    }
}
