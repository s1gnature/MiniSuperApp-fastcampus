//
//  AddPaymentMethodButton.swift
//  MiniSuperApp
//
//  Created by narr on 10/9/24.
//

import UIKit

final class AddPaymentMethodButton: UIControl {

    private let plusIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24,
            weight: .semibold))
        )
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(plusIcon)

        NSLayoutConstraint.activate([
            plusIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            plusIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
