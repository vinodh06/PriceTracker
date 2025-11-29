//
//  TestFeedScheduler.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 29/11/25.
//


class TestFeedScheduler: FeedSchedulerProtocol {
    func start(action: @escaping () -> Void) {
        action()
    }
    
    func stop() {
    }
}
