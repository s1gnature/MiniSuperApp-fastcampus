//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by narr on 10/9/24.
//

import UIKit

struct PaymentMethodViewModel {

    let name: String
    let digits: String
    let color: UIColor

    init(_ paymentMethodModel: PaymentMethodModel) {
        self.name = paymentMethodModel.name
        self.digits = "**** \(paymentMethodModel.digits)"
        self.color = UIColor(hex: paymentMethodModel.color) ?? .red
    }
}
