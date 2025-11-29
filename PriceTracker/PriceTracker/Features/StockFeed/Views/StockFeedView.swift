//
//  StockFeedView.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 28/11/25.
//


import SwiftUI

struct StockFeedView: View {
    @State var viewModel: StockFeedViewModel
    
    init(environment: AppEnvironment = .real) {
        self.viewModel = StockFeedViewModel(environment: environment)
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.stocks) { stock in
                NavigationLink(
                    destination: StockFeedDetailView(stockQuote: stock)
                ) {
                    StockFeedItemView(stock: stock)
                }
            }
            .animation(.default, value: viewModel.stocks)
            .navigationBarHidden(true)
            .safeAreaInset(edge: .top, spacing: 0) {
                CustomToolbar()
            }
            .environment(viewModel)
        }
    }
}

struct CustomToolbar: View {
    @Environment(StockFeedViewModel.self) var viewModel
    
    var body: some View {
        Text("Feed")
            .font(.largeTitle)
            .frame(height: 64)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .center) {
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(viewModel.isSocketConnected ? .green : .red)
                            .frame(width: 20, height: 20)
                        Text(viewModel.socketConnectionState.connectionStatusText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(viewModel.isSocketConnected ? "Stop" : "Start") {
                        viewModel.actConnect()
                    }
                    .font(.title3)
                    .disabled(viewModel.socketConnectionState == .connecting)
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
    StockFeedView(environment: .mock)
}
