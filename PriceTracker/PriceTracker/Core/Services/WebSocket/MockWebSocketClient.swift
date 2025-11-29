//
//  MockWebSocketClient.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 29/11/25.
//

import Combine

class MockWebSocketClient: WebSocketClientProtocol {
    private let messageSubject = PassthroughSubject<[StockQuote], Never>()
    private let connectionSubject = CurrentValueSubject<WebSocketConnectionState, Never>(.disconnected)
    
    var messagePublisher: AnyPublisher<[StockQuote], Never> {
        messageSubject.eraseToAnyPublisher()
    }
    
    var connectionPublisher: AnyPublisher<WebSocketConnectionState, Never> {
        connectionSubject.eraseToAnyPublisher()
    }

    func connect() {
        connectionSubject.send(.connected)
    }

    func disconnect() {
        connectionSubject.send(.disconnected)
    }

    func send(_ stocks: [StockQuote]) {
        messageSubject.send(stocks)
    }

    func receive() {
    }
}
