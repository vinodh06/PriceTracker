//
//  WebSocketFactory.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 29/11/25.
//

import Foundation

struct WebSocketFactory {
    static func makeService(for environment: AppEnvironment) -> WebSocketClientProtocol {
        switch environment {
        case .real:
            return RealWebSocketClient(
                url: Constant.url,
                session: URLSession(configuration: .default)
            )
        }
    }
}
