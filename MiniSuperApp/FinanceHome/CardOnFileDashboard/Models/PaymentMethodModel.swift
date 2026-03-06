//
//  PaymentMethodModel.swift
//  MiniSuperApp
//
//  Created by narr on 10/9/24.
//

import Foundation

struct PaymentMethodModel: Decodable {

    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}
