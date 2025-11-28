//
//  StockFeedDetailView.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 28/11/25.
//


import SwiftUI

struct StockFeedDetailView: View {
    let stockQuote: StockQuote
    
    var body: some View {
        VStack(spacing: 20) {
            Text(stockQuote.tickerSymbol)
                .font(.largeTitle)
            
            Text(stockQuote.description)
                .font(.title)
            
            HStack {
                Text(stockQuote.formattedCurrentPrice)
                    .font(.title)
                
                switch stockQuote.priceTrend {
                case .up:
                    Image(systemName: "arrow.up")
                        .foregroundStyle(.green)
                case .down:
                    Image(systemName: "arrow.down")
                        .foregroundStyle(.red)
                case .noChange:
                    Image(systemName: "minus")
                }
                
            }
        }
        .padding()
    }
}

#Preview {
    let stockQuote = StockQuote(
        tickerSymbol: "AAPL",
        description: "Apple Inc.",
        currentPrice: 100.00,
        previousPrice: 120.00
    )
    StockFeedDetailView(stockQuote: stockQuote)
}
