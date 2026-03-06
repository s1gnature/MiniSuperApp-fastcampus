//
//  CardOnFileDashboardViewController.swift
//  MiniSuperApp
//
//  Created by narr on 10/5/24.
//

import ModernRIBs
import UIKit

protocol CardOnFileDashboardPresentableListener: AnyObject {
    
    func didTapAddPaymentMethod()
}

final class CardOnFileDashboardViewController: UIViewController, CardOnFileDashboardPresentable, CardOnFileDashboardViewControllable {

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
        label.text = "카드 및 계좌"
        return label
    }()
    private lazy var seeAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("전체보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(seeAllButtonDidTap), for: .touchUpInside)
        return button
    }()
    private lazy var cardOnFileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    private lazy var addMethodButton: AddPaymentMethodButton = {
        let button = AddPaymentMethodButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCorners()
        button.backgroundColor = .systemGray4
        button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
        return button
    }()

    weak var listener: CardOnFileDashboardPresentableListener?

    init() {
        super.init(nibName: nil, bundle: nil)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: - Public

    func update(with viewModels: [PaymentMethodViewModel]) {
        cardOnFileStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let views = viewModels.map { PaymentMethodView(viewModel: $0) }
        views.forEach {
            cardOnFileStackView.addArrangedSubview($0)
            NSLayoutConstraint.activate([$0.heightAnchor.constraint(equalToConstant: 60)])
        }
        cardOnFileStackView.addArrangedSubview(addMethodButton)
        NSLayoutConstraint.activate([addMethodButton.heightAnchor.constraint(equalToConstant: 60)])
    }

    private func configureUI() {
        view.translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Hierarchy

        [
            titleStackView,
            cardOnFileStackView
        ].forEach { view.addSubview($0) }

        [
            titleLabel,
            seeAllButton
        ].forEach { titleStackView.addArrangedSubview($0) }

        // MARK: - Constraints

        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            cardOnFileStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 10),
            cardOnFileStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardOnFileStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardOnFileStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
        ])
    }

    // MARK: = Private

    @objc
    private func seeAllButtonDidTap() {
        print("seeAllButtonDidTap!")
    }

    @objc
    private func addButtonDidTap() {
        listener?.didTapAddPaymentMethod()
    }
}
