//
//  Debouncer.swift
//  Debouncer&Throttler
//
//  Created by zhanx630 on 2021/12/7.
//

import Foundation

public typealias WrappedFunc = () -> Void

public class Debouncer {
    private let timeInterval: DispatchTimeInterval
    private let wrappedFunc: WrappedFunc
    private var workItem: DispatchWorkItem

    public init(_ timeInterval: DispatchTimeInterval, _ wrappedFunc: @escaping WrappedFunc) {
        self.timeInterval = timeInterval
        self.wrappedFunc = wrappedFunc
        workItem = DispatchWorkItem { wrappedFunc() }
    }

    public func call() {
        workItem.cancel()
        workItem = DispatchWorkItem { [weak self] in self?.wrappedFunc() }
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval, execute: workItem)
    }
}
