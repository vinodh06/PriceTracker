//
//  FeedScheduler.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 29/11/25.
//

import Combine
import Foundation

class RealFeedScheduler: FeedSchedulerProtocol {
    private var timerCancellable: AnyCancellable?
    
    func start(action: @escaping () -> Void) {
        timerCancellable?.cancel()
        timerCancellable = Timer
            .publish(every: 2.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in action() }
    }
    
    func stop() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    deinit {
        stop()
    }
}
