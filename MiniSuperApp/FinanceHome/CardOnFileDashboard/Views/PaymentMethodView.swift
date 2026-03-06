//
//  PaymentMethodView.swift
//  MiniSuperApp
//
//  Created by narr on 10/9/24.
//

import UIKit

final class PaymentMethodView: UIView {

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        return label
    }()

    init(viewModel: PaymentMethodViewModel) {
        super.init(frame: .zero)
        setupView()

        nameLabel.text = viewModel.name
        subtitleLabel.text = viewModel.digits
        backgroundColor = viewModel.color
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .systemIndigo
        roundCorners()

        [
            nameLabel,
            subtitleLabel
        ].forEach { addSubview($0) }

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            subtitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
