//
//  PriceTrackerTests.swift
//  PriceTrackerTests
//
//  Created by Vinodhkumar Govindaraj on 29/11/25.
//

import XCTest
@testable import PriceTracker

@MainActor
final class PriceTrackerViewModelTests: XCTestCase {
    
    var sut: StockFeedViewModel!

    override func setUp() {
        super.setUp()
        sut = StockFeedViewModel(environment: .test)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_initialState() {
        XCTAssertEqual(sut.socketConnectionState, .disconnected)
        XCTAssertFalse(sut.isSocketConnected)
        XCTAssertEqual(sut.stocks.count, 25)
    }
    
    func test_connectSocket() {
        let expectation = expectation(description: "Connection state updated")
        
        XCTAssertEqual(sut.socketConnectionState, .disconnected)
        
        sut.connect()
        
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertEqual(sut.socketConnectionState, .connected)
        XCTAssertTrue(sut.isSocketConnected)
    }
    
    func test_disconnectSocket() {
        
        sut.socketConnectionState = .connected
        
        let expectation = expectation(description: "Connection state updated")
        
        XCTAssertEqual(sut.socketConnectionState, .connected)
        
        sut.disconnect()
        
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertEqual(sut.socketConnectionState, .disconnected)
        XCTAssertFalse(sut.isSocketConnected)
    }
    
    func test_StockUpdate() async throws {
        let testWebSocketClient = TestWebSocketClient()
        let testScheduler = TestFeedScheduler()
        let sut = StockFeedViewModel(
            webSocketClient: testWebSocketClient,
            scheduler: testScheduler
        )
        
        sut.connect()
        try await Task.sleep(for: .milliseconds(50))
        
        XCTAssertEqual(sut.socketConnectionState, .connected)
        
        let stock = StockQuote(tickerSymbol: "AAPL", description: "", currentPrice: 200.00)
        testWebSocketClient.send([stock])
        
        try await Task.sleep(for: .milliseconds(50))
        
        XCTAssertEqual(sut.stocks.first?.tickerSymbol, "AAPL")
        XCTAssertEqual(sut.stocks.first?.currentPrice, 200.0)
        
        let updatedStock = stock.withUpdatedPrice(201.0)
        testWebSocketClient.send([updatedStock])
        
        try await Task.sleep(for: .milliseconds(50))
        
        XCTAssertEqual(sut.stocks.first?.currentPrice, 201.0)
    }
    
    func test_Sort() async throws {
        let testWebSocketClient = TestWebSocketClient()
        let testScheduler = TestFeedScheduler()
        let sut = StockFeedViewModel(
            webSocketClient: testWebSocketClient,
            scheduler: testScheduler
        )
        
        sut.connect()
        try await Task.sleep(for: .milliseconds(50))
        
        XCTAssertEqual(sut.socketConnectionState, .connected)
        
        var stock1 = StockQuote(tickerSymbol: "AAPL", description: "", currentPrice: 200.00)
        var stock2 = StockQuote(tickerSymbol: "GOOGL", description: "", currentPrice: 300.00)
        testWebSocketClient.send([stock1, stock2])
        
        try await Task.sleep(for: .milliseconds(50))
        
        XCTAssertTrue(sut.stocks[0] == stock2)
        
        stock1 = stock1.withUpdatedPrice(350.0)
        testWebSocketClient.send([stock1, stock2])
        
        try await Task.sleep(for: .milliseconds(50))
        
        XCTAssertTrue(sut.stocks[0] == stock1)
    }

}
