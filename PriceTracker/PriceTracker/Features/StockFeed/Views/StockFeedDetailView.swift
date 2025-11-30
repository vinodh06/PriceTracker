//
//  StockFeedDetailView.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 28/11/25.
//


import SwiftUI

struct StockFeedDetailView: View {
    @Environment(StockFeedViewModel.self) private var viewModel
    let tickerSymbol: String
    
    private var stock: StockQuote? {
        viewModel.stocks.first(where: { $0.tickerSymbol == tickerSymbol })
    }
    
    var body: some View {
        if let stock {
            VStack(spacing: 20) {
                Text(stock.tickerSymbol)
                    .font(.largeTitle)
                
                Text(stock.description)
                    .font(.title)
                
                HStack {
                    Text(stock.formattedCurrentPrice)
                        .font(.title)
                        .contentTransition(.numericText())
                    
                    switch stock.priceTrend {
                    case .up:
                        Image(systemName: "arrow.up")
                            .foregroundStyle(.green)
                            .symbolEffect(.bounce, value: stock.currentPrice)
                    case .down:
                        Image(systemName: "arrow.down")
                            .foregroundStyle(.red)
                            .symbolEffect(.bounce, value: stock.currentPrice)
                    case .noChange:
                        Image(systemName: "minus")
                    }
                }
            }
            .padding()
            .animation(.easeInOut(duration: 0.5), value: stock.currentPrice)
        } else {
            Text("Stock not found")
                .font(.title)
                .foregroundStyle(.secondary)
        }
    }
}
