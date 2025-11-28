//
//  StockFeedViewModel.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 28/11/25.
//


import Combine
import Foundation
import Observation

@Observable
class StockFeedViewModel {
    var stocks: [StockQuote] = StockQuote.data.sorted {
        $0.currentPrice > $1.currentPrice
    }
    
    var isConnected = false
    var isRunning = false
    
    private var webSocket: URLSessionWebSocketTask?
    private var timerCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    private let messageSubject = PassthroughSubject<Data, Never>()
    private let connectionSubject = CurrentValueSubject<Bool, Never>(false)
    
    var messagePublisher: AnyPublisher<Data, Never> {
        messageSubject.eraseToAnyPublisher()
    }

    var connectionStatePublisher: AnyPublisher<Bool, Never> {
        connectionSubject.eraseToAnyPublisher()
    }
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        messagePublisher
            .decode(type: [StockQuote].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newStocks in
                self?.stocks = newStocks.sorted {
                    $0.currentPrice > $1.currentPrice
                }
            }
            .store(in: &cancellables)
        
        connectionStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connected in
                self?.isConnected = connected
            }
            .store(in: &cancellables)
    }
    
    func connect() {
        guard !isConnected else { return }
        
        let url = URL(string: "wss://ws.postman-echo.com/raw")!
        webSocket = URLSession.shared.webSocketTask(with: url)
        webSocket?.resume()

        isConnected = true
        connectionSubject.send(true)
        listen()
        
        startFeed()
    }
    
    func disconnect() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        connectionSubject.send(false)
        stopFeed()
    }
    
    func send(_ stocks: [StockQuote]) {
        guard let webSocket = webSocket else {
            return
        }

        guard webSocket.state == .running else {
            return
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(stocks)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let message = URLSessionWebSocketTask.Message.string(jsonString)

                webSocket.send(message) { error in
                    if let error = error {
                        print("Error: \(error)")
                    }
                }
            }
        } catch {
            print("Encoding Error: \(error)")
        }
    }
    
    private func listen() {
        webSocket?.receive { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    if let data = text.data(using: .utf8) {
                        self.messageSubject.send(data)
                    }
                    
                default:
                    print("Unknown Message type")
                    break
                }
                self.listen()
                
            case .failure(let error):
                print("Recieve error: \(error)")
                self.connectionSubject.send(false)
            }
        }
    }
    
    func startFeed() {
        guard isConnected && !isRunning else { return }
        isRunning = true
        
        timerCancellable = Timer
            .publish(every: 2.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.sendPriceUpdates()
            }
    }
    
    func stopFeed() {
        timerCancellable?.cancel()
        timerCancellable = nil
        isRunning = false
    }
    
    func sendPriceUpdates() {
        let stockUpdates = stocks.map { $0.withUpdatedPrice(Double.random(in: 200...500)) }
        self.send(stockUpdates)
    }
    
    deinit {
        disconnect()
    }
}

