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
    // MARK: - Published Properties
    var stocks: [StockQuote] = []
    var socketConnectionState: WebSocketConnectionState = .disconnected
    
    // MARK: - Computed Properties
    var isSocketConnected: Bool {
        socketConnectionState.isConnected
    }

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let webSocketClient: WebSocketClientProtocol
    private let scheduler: FeedSchedulerProtocol
    
    // MARK: - Initialization
    init(environment: AppEnvironment) {
        self.webSocketClient = WebSocketFactory.makeService(for: environment)
        self.scheduler = FeedSchedulerFactory.makeService(for: environment)
        
        setupWebSocketSubscriptions()
    }

    // MARK: - Setup
    private func setupWebSocketSubscriptions() {
        // Subscribe to stock messages
        webSocketClient.messagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stocks in
                self?.handleStockUpdate(stocks)
            }
            .store(in: &cancellables)
        
        // Subscribe to connection state
        webSocketClient.connectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connectionState in
                self?.handleConnectionStateChange(connectionState)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func handleStockUpdate(_ stocks: [StockQuote]) {
        self.stocks = sortStocks(stocks)
    }
    
    private func handleConnectionStateChange(_ newState: WebSocketConnectionState) {
        socketConnectionState = newState
        if socketConnectionState.isConnected {
            startFeed()
        } else {
            stopFeed()
        }
    }
    
    private func sortStocks(_ stocks: [StockQuote]) -> [StockQuote] {
        stocks.sorted { $0.currentPrice > $1.currentPrice }
    }
    
    // MARK: - Public Methods
    func connect() {
        webSocketClient.connect()
    }
    
    func disconnect() {
        webSocketClient.disconnect()
    }
    
    func startFeed() {
        guard isSocketConnected else {
            return
        }
        
        scheduler.start { [weak self] in
            self?.sendPriceUpdates()
        }
    }
    
    func stopFeed() {
        scheduler.stop()
    }
    
    func sendPriceUpdates() {
        guard isSocketConnected else {
            return
        }

        let stocksToUpdate = stocks.isEmpty ? StockQuote.data : stocks
        let updatedStocks = stocksToUpdate.map {
            $0.withUpdatedPrice(Double.random(in: 100...500))
        }
        
        webSocketClient.send(updatedStocks)
    }
    
    // MARK: - Deinitialization
    deinit {
        disconnect()
        print("StockFeedViewModel deinitialized")
    
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

// MARK: UIActions
extension StockFeedViewModel {
    func actConnect() {
        isSocketConnected ? disconnect() : connect()
    }
}
