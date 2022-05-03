//
//  Throttler.swift
//  Debouncer&Throttler
//
//  Created by zhanx630 on 2021/12/7.
//

import Foundation

public class Throttler {
    private let timeInterval: Double
    private let wrappedFunc: WrappedFunc
    private var currentLoopTime: CFAbsoluteTime = 0
    public init(_ timeInterval: DispatchTimeInterval, _ wrappedFunc: @escaping WrappedFunc) {
        self.wrappedFunc = wrappedFunc
        self.timeInterval = timeInterval.transToDouble()
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

        if curTime - currentLoopTime <= timeInterval {
            currentLoopTime += timeInterval
            let time = Int(timeInterval - (curTime - currentLoopTime) * 1000000)
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

extension DispatchTimeInterval {
    
    func transToDouble() -> Double {
        var ans: Double = 0
        
        switch self {
        case let .seconds(num):
            ans = Double(num)
        case let .milliseconds(num):
            ans = Double(num) / 1000
        case let .microseconds(num):
            ans = Double(num) / 1000000
        case let .nanoseconds(num):
            ans = Double(num) / 1000000000
        case .never:
            ans = 0
        @unknown default:
            fatalError()
        }
        
        return ans
    }
}
