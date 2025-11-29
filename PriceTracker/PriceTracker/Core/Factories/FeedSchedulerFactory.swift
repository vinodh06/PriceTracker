//
//  FeedSchedulerFactory.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 29/11/25.
//

import Foundation

struct FeedSchedulerFactory {
    static func makeService(for environment: AppEnvironment) -> FeedSchedulerProtocol {
        switch environment {
        case .real:
            return RealFeedScheduler()
        
        case .mock:
            return MockFeedScheduler()
        }
    }
}
