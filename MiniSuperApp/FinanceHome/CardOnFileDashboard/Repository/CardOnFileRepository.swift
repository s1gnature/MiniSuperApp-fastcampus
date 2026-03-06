//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by narr on 10/9/24.
//

import Foundation
import Combine

/*
 이 Repository 의 역할은 서버 API 호출을 해서 그 유저에게 등록된 카드 목록을 가져온다.
 */
protocol CardOnFileRepository {

    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethodModel]> { get }
    func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethodModel, Error>
}

final class CardOnFileRepositoryImpl: CardOnFileRepository {

    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethodModel]> { paymentMethodsSubject }

    private let paymentMethodsSubject = CurrentValuePublisher<[PaymentMethodModel]>([
        PaymentMethodModel(
            id: "0",
            name: "우리은행",
            digits: "0123",
            color: "#f19a38ff",
            isPrimary: false
        ),
        PaymentMethodModel(
            id: "1",
            name: "신한카드",
            digits: "0812",
            color: "#129384ff",
            isPrimary: false
        ),
    ])
    
    func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethodModel, any Error> {
        let paymentMethod = PaymentMethodModel(
            id: "00",
            name: "New Card",
            digits: "\(info.number.suffix(4))",
            color: "",
            isPrimary: false
        )
        var new = paymentMethodsSubject.value
        new.append(paymentMethod)
        paymentMethodsSubject.send(new)
        
        return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
