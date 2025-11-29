//
//  WebSocketClientProtocol.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 29/11/25.
//

import Combine

protocol WebSocketClientProtocol {
    var messagePublisher: AnyPublisher<[StockQuote], Never> { get }
    var connectionPublisher: AnyPublisher<WebSocketConnectionState, Never> { get }
    
    func connect()
    func disconnect()
    func send(_ stocks: [StockQuote])
    func receive()
}
