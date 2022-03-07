//
//  YXKitFPS.swift
//  YXSwiftKitUtil_Example
//
//  Created by Mr_Jesson on 2022/3/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

open class YXKitFPS {
    private var displayLink: CADisplayLink?     //fps显示
    private var lastTime: TimeInterval = 0
    private var count = 0
    private var complete: ((Int) -> Void)?
    public var isRunning = false

    public init() {}

    public func start(success: ((Int) -> Void)?) {
        if self.isRunning {
            self.stop()
        }
        isRunning = true
        self.complete = success
        self.displayLink = CADisplayLink(target: self, selector: #selector(tick(link:)))
        self.displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }

    public func stop() {
        #if canImport(YXKitCore)
        YXKit.resetFloatButton()
        #endif
        lastTime = 0
        count = 0
        isRunning = false
        self.displayLink?.invalidate()
    }
}

private extension YXKitFPS {
    @objc func tick(link: CADisplayLink) {
        guard lastTime != 0 else {
            lastTime = link.timestamp
            return
        }
        count = count + 1
        let delta = link.timestamp - lastTime
        guard delta >= 1 else { return }
        lastTime = link.timestamp
        let fps = round(Double(count) / delta)
        count = 0
        if let complete = complete {
            complete(Int(fps))
        }
    }
}
