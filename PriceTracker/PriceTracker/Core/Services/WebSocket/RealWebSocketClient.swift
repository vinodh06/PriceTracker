//
//  RealWebSocketClient.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 29/11/25.
//

import Foundation
import Combine

class RealWebSocketClient {
    
    // MARK: - Private Properties
    private var task: URLSessionWebSocketTask?
    private let url: URL
    private let session: URLSession
    
    private let messageSubject = PassthroughSubject<[StockQuote], Never>()
    private let connectionSubject = CurrentValueSubject<WebSocketConnectionState, Never>(.disconnected)
    
    
    var isConnected: Bool {
        connectionSubject.value.isConnected
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Properties
    var messagePublisher: AnyPublisher<[StockQuote], Never> {
        messageSubject.eraseToAnyPublisher()
    }
    
    var connectionPublisher: AnyPublisher<WebSocketConnectionState, Never> {
        connectionSubject.eraseToAnyPublisher()
    }

    // MARK: - Initialization
    init(url: URL, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }
    
    // MARK: - Deinitialization
    deinit {
        disconnect()
        print("RealWebSocketClient deinitialized")
    }
}

// MARK: - WebSocketClientProtocol Methods
extension RealWebSocketClient: WebSocketClientProtocol {
    
    func connect() {
        guard task == nil else {
            return
        }
        
        task = session.webSocketTask(with: url)
        task?.resume()
        
        self.connectionSubject.send(.connecting)
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            self.connectionSubject.send(.connected)
            self.receive()
        }
    }
    
    func disconnect() {
        guard task != nil else {
            print("WebSocket already disconnected")
            return
        }

        task?.cancel()
        task = nil
        
        print("WebSocket disconnected")
        connectionSubject.send(.disconnected)
    }
    
    func send(_ stocks: [StockQuote]) {
        guard task != nil else {
            connectionSubject.send(.failed("Not connected"))
            return
        }
        do {
            let data = try encode(stocks: stocks)
            if let jsonString = String(data: data, encoding: .utf8) {
                let message = URLSessionWebSocketTask.Message.string(jsonString)
                task?.send(message) { [weak self] error in
                    if let error = error {
                        self?.connectionSubject
                            .send(.failed(error.localizedDescription))
                    }
                }
            }
        } catch {
            connectionSubject.send(.failed(error.localizedDescription))
        }
    }
    
    func receive() {
        guard task != nil else { return }
        
        task?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                self.handleMessage(message)
                // Continue listening for next message
                self.receive()
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Extension - Private Helper Methods
extension RealWebSocketClient {
    
    private func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let text):
            if let data = text.data(using: .utf8) {
                decodeStocks(from: data)
            }
            
        case .data(let data):
            decodeStocks(from: data)
            
        default:
            print("Unknown message type received")
        }
    }
 
    private func decodeStocks(from data: Data) {
        do {
            let decoder = JSONDecoder()
            let stocks = try decoder.decode([StockQuote].self, from: data)
            messageSubject.send(stocks)
        } catch {
            print("Decoding error: \(error.localizedDescription)")
        }
    }
    
    func encode(stocks: [StockQuote]) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(stocks)
    }
}
