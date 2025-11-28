//
//  StockFeedView.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 28/11/25.
//


import SwiftUI

struct StockFeedView: View {
    @State var stocks: [StockQuote] = []
    @State var isConnected: Bool = false
    
    var body: some View {
        NavigationStack {
            NavigationStack {
                List(stocks) { stock in
                    StockFeedItemView(stock: stock)
                }
            }
            .navigationBarHidden(true)
            .safeAreaInset(edge: .top, spacing: 0) {
                CustomToolbar(isConnected: $isConnected)
            }
        }
    }
}

struct CustomToolbar: View {
    @Binding var isConnected: Bool
    
    var body: some View {
        Text("Feed")
            .font(.largeTitle)
            .frame(height: 64)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .center) {
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(isConnected ? .green : .red)
                            .frame(width: 20, height: 20)
                        Text(isConnected ? "Connected" : "Disconnected")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(isConnected ? "Stop" : "Start") {
                        isConnected.toggle()
                    }
                    .font(.title3)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .background(.ultraThinMaterial)
    }
}

struct StockFeedItemView: View {
    let stock: StockQuote
    
    var body: some View {
        HStack {
            Text(stock.tickerSymbol)
            Spacer()
            Text(stock.formattedCurrentPrice)
            
            switch stock.priceTrend {
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
        .font(.title3)
        .foregroundStyle(.primary)
    }
}

#Preview {
    StockFeedView(stocks: StockQuote.data)
}
