//
//  StockQuote.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 28/11/25.
//

import Foundation
import Observation

// MARK: - StockQuote
@Observable
final class StockQuote: Codable, Equatable, Hashable {
    let tickerSymbol: String
    let description: String
    var currentPrice: Double
    var previousPrice: Double?
    
    init(
        tickerSymbol: String,
        description: String,
        currentPrice: Double,
        previousPrice: Double? = nil
    ) {
        self.tickerSymbol = tickerSymbol
        self.description = description
        self.currentPrice = currentPrice
        self.previousPrice = previousPrice
    }
    
    enum CodingKeys: String, CodingKey {
        case tickerSymbol
        case description
        case currentPrice
        case previousPrice
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tickerSymbol = try container.decode(String.self, forKey: .tickerSymbol)
        description = try container.decode(String.self, forKey: .description)
        currentPrice = try container.decode(Double.self, forKey: .currentPrice)
        previousPrice = try container.decodeIfPresent(Double.self, forKey: .previousPrice)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tickerSymbol, forKey: .tickerSymbol)
        try container.encode(description, forKey: .description)
        try container.encode(currentPrice, forKey: .currentPrice)
        try container.encodeIfPresent(previousPrice, forKey: .previousPrice)
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(tickerSymbol)
    }
    
    // MARK: - Equatable
    static func == (lhs: StockQuote, rhs: StockQuote) -> Bool {
        lhs.tickerSymbol == rhs.tickerSymbol
    }
}

// MARK: - Identifiable
extension StockQuote: Identifiable {
    var id: String { tickerSymbol }
}

// MARK: - Computed Properties
extension StockQuote {
    var formattedCurrentPrice: String {
        String(format: "$%.2f", currentPrice)
    }
    
    var priceTrend: PriceTrend {
        guard let previous = previousPrice else { return .noChange }
        if currentPrice > previous { return .up }
        if currentPrice < previous { return .down }
        return .noChange
    }

    enum PriceTrend {
        case up
        case down
        case noChange
    }

    func withUpdatedPrice(_ newPrice: Double) -> StockQuote {
        previousPrice = currentPrice
        currentPrice = newPrice
        return self
    }
}

// MARK: - PreviewData
extension StockQuote {
    static var data: [StockQuote] {
        [
            StockQuote(
                tickerSymbol: "AAPL",
                description: "Apple Inc.",
                currentPrice: 201.55,
                previousPrice: 200.00
            ),
            StockQuote(
                tickerSymbol: "MSFT",
                description: "Microsoft Corporation",
                currentPrice: 358.75,
                previousPrice: 400.00
            ),
            StockQuote(
                tickerSymbol: "GOOGL",
                description: "Alphabet Inc.",
                currentPrice: 303.66
            ),
            StockQuote(
                tickerSymbol: "AMZN",
                description: "Amazon.com, Inc.",
                currentPrice: 372.96
            ),
            StockQuote(
                tickerSymbol: "META",
                description: "Meta Platforms, Inc.",
                currentPrice: 160.94
            ),
            StockQuote(
                tickerSymbol: "TSLA",
                description: "Tesla, Inc.",
                currentPrice: 217.04
            ),
            StockQuote(
                tickerSymbol: "NVDA",
                description: "NVIDIA Corporation",
                currentPrice: 183.07
            ),
            StockQuote(
                tickerSymbol: "NFLX",
                description: "Netflix, Inc.",
                currentPrice: 400.64
            ),
            StockQuote(
                tickerSymbol: "INTC",
                description: "Intel Corporation",
                currentPrice: 147.12
            ),
            StockQuote(
                tickerSymbol: "IBM",
                description: "International Business Machines Corporation",
                currentPrice: 201.92
            ),
            StockQuote(
                tickerSymbol: "ORCL",
                description: "Oracle Corporation",
                currentPrice: 270.75
            ),
            StockQuote(
                tickerSymbol: "ADBE",
                description: "Adobe Inc.",
                currentPrice: 224.00
            ),
            StockQuote(
                tickerSymbol: "PYPL",
                description: "PayPal Holdings, Inc.",
                currentPrice: 393.90
            ),
            StockQuote(
                tickerSymbol: "V",
                description: "Visa Inc.",
                currentPrice: 208.77
            ),
            StockQuote(
                tickerSymbol: "MA",
                description: "Mastercard Incorporated",
                currentPrice: 371.69
            ),
            StockQuote(
                tickerSymbol: "JPM",
                description: "JPMorgan Chase & Co.",
                currentPrice: 449.43
            ),
            StockQuote(
                tickerSymbol: "BAC",
                description: "Bank of America Corporation",
                currentPrice: 350.78
            ),
            StockQuote(
                tickerSymbol: "COST",
                description: "Costco Wholesale Corporation",
                currentPrice: 253.32
            ),
            StockQuote(
                tickerSymbol: "WMT",
                description: "Walmart Inc.",
                currentPrice: 456.85
            ),
            StockQuote(
                tickerSymbol: "DIS",
                description: "The Walt Disney Company",
                currentPrice: 467.27
            ),
            StockQuote(
                tickerSymbol: "MCD",
                description: "McDonald's Corporation",
                currentPrice: 103.02
            ),
            StockQuote(
                tickerSymbol: "KO",
                description: "The Coca-Cola Company",
                currentPrice: 353.78
            ),
            StockQuote(
                tickerSymbol: "PEP",
                description: "PepsiCo, Inc.",
                currentPrice: 203.86
            ),
            StockQuote(
                tickerSymbol: "BA",
                description: "The Boeing Company",
                currentPrice: 394.05
            ),
            StockQuote(
                tickerSymbol: "CSCO",
                description: "Cisco Systems, Inc.",
                currentPrice: 218.51
            )
        ]
    }
}
