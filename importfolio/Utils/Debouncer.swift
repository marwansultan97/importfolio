//
//  Debouncer.swift
//  importfolio
//
//  Created by Marwan Osama on 05/10/2021.
//

import Foundation

public class Debouncer: NSObject {
    public var callback: (() -> Void)
    public var delay: Double
    public weak var timer: Timer?

    public init(delay: Double, callback: @escaping (() -> Void)) {
        self.delay = delay
        self.callback = callback
    }

    public func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(Debouncer.fireNow), userInfo: nil, repeats: false)
        timer = nextTimer
    }

    @objc func fireNow() {
        self.callback()
    }
}
