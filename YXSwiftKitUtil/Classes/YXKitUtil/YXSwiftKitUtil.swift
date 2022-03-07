//
//  YXSwiftKitUtil.swift
//  YXSwiftKitUtil_Example
//
//  Created by Mr_Jesson on 2022/3/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

open class YXSwiftKitUtil: NSObject {
    private static let instance = YXSwiftKitUtil()
    open class var shared: YXSwiftKitUtil {
        return instance
    }
}
