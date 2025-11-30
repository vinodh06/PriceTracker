# PriceTracker
Real time price tracker app for coding challenge in Multibank

## Features

- **Real-time Price Updates**: Stock prices refresh every 2 seconds via WebSocket simulation
- **Live Feed View**: Scrollable list of stocks with current prices and trend indicators
- **Detail View**: Individual stock details with animated price changes
- **Deep Linking**: Navigate directly to specific stocks via URL scheme (`pricetracker://stock/AAPL`)
- **Connection Status**: Visual indicator showing WebSocket connection state
- **Automatic Sorting**: Stocks sorted by current price (highest to lowest)
- **Dark Mode Support**: Full support for iOS light and dark themes

## 🏗️ Architecture

### MVVM + Dependency Injection
- **SwiftUI Views**: `StockFeedView`, `StockFeedDetailView`
- **ViewModel**: `StockFeedViewModel` with `@Observable`
- **Protocols**: `WebSocketClientProtocol`, `FeedSchedulerProtocol`
- **Factory Pattern**: Environment-based service creation (`.real`, `.mock`, `.test`)

## Deep Linking Setup

The app supports custom URL scheme deep linking:

### URL Format
symbols://stock/<TICKER_SYMBOL>

### Examples
- `symbols://stock/AAPL` - Opens Apple Inc.
- `symbols://stock/GOOGL` - Opens Alphabet Inc.
- `symbols://stock/TSLA` - Opens Tesla, Inc.

## 👨‍💻 Author

**Vinodhkumar Govindaraj**  
iOS Developer | 14+ Years Experience  

[LinkedIn](https://www.linkedin.com/in/vinodhkumar-govindaraj-838a85100/) | [Medium](https://medium.com/@vinodh_36508)
