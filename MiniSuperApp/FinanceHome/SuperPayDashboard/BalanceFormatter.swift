//
//  BalanceFormatter.swift
//  MiniSuperApp
//
//  Created by narr on 5/6/24.
//

import Foundation

struct BalanceFormatter {

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
