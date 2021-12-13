//
//  Throttler.swift
//  Debouncer&Throttler
//
//  Created by zhanx630 on 2021/12/7.
//

import Foundation

public class Throttler {
    private let interval: Double
    private let wrappedFunc: WrappedFunc
    private var currentLoopTime: CFAbsoluteTime = 0
    public init(_ timeInterval: DispatchTimeInterval, _ wrappedFunc: @escaping WrappedFunc) {
        self.wrappedFunc = wrappedFunc
        switch timeInterval {
        case let .seconds(num):
            interval = Double(num)
        case let .milliseconds(num):
            interval = Double(num) / 1000
        case let .microseconds(num):
            interval = Double(num) / 1000000
        case let .nanoseconds(num):
            interval = Double(num) / 1000000000
        case .never:
            interval = 0
        @unknown default:
            fatalError()
        }
    }

    public func call() {
        if currentLoopTime == 0 {
            currentLoopTime = CFAbsoluteTimeGetCurrent()
            DispatchQueue.main.async {
                self.wrappedFunc()
            }
            return
        }

        let curTime = CFAbsoluteTimeGetCurrent()

        if curTime - currentLoopTime < 0 {
            return
        }

        if curTime - currentLoopTime <= interval {
            currentLoopTime += interval
            let time = Int(interval - (curTime - currentLoopTime) * 1000000)
            DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(time)) {
                self.wrappedFunc()
            }
            return
        }

        currentLoopTime = curTime
        DispatchQueue.main.async {
            self.wrappedFunc()
        }
    }
}
