//
//  WebSocketConnectionState.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 29/11/25.
//


enum WebSocketConnectionState: Equatable {
    case disconnected
    case connecting
    case connected
    case failed(String)
}

extension WebSocketConnectionState {
    var isConnected: Bool {
        if case .connected = self { return true }
        return false
    }
    
    var connectionStatusText: String {
        switch self {
        case .disconnected: return "Disconnected"
        case .connecting: return "Connecting..."
        case .connected: return "Connected"
        case .failed: return "Disconnected"
        }
    }
}