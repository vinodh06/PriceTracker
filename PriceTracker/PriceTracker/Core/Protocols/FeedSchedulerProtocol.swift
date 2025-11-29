//
//  FeedSchedulerProtocol.swift
//  PriceTracker
//
//  Created by Vinodhkumar Govindaraj on 29/11/25.
//

protocol FeedSchedulerProtocol {
    func start(action: @escaping () -> Void)
    func stop()
}
