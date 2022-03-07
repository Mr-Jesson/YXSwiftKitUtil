//
//  LogContent.swift
//  YXSwiftKitUtil_Example
//
//  Created by Mr_Jesson on 2022/3/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//


import Foundation

//输出内容需要遵循的协议
public protocol LogContent {
    var logStringValue: String { get }
}

///默认的几个输出类型
extension Dictionary: LogContent {
    public var logStringValue: String {
        if JSONSerialization.isValidJSONObject(self) {
            let data = try? JSONSerialization.data(withJSONObject: self, options:JSONSerialization.WritingOptions.prettyPrinted)
            if let data = data {
                let string = String(data: data, encoding: String.Encoding.utf8) ?? "\(self)"
                return string.yx.unicodeDecode()
            } else {
                let string = "\(self)"
                return string.yx.unicodeDecode()
            }
        } else {
            let string = "\(self)"
            return string.yx.unicodeDecode()
        }
    }
}

extension Array: LogContent {
    public var logStringValue: String {
        if JSONSerialization.isValidJSONObject(self) {
            let data = try? JSONSerialization.data(withJSONObject: self, options:JSONSerialization.WritingOptions.prettyPrinted)
            if let data = data {
                let string = String(data: data, encoding: String.Encoding.utf8) ?? "\(self)"
                return string.yx.unicodeDecode()
            } else {
                let string = "\(self)"
                return string.yx.unicodeDecode()
            }
        } else {
            let string = "\(self)"
            return string.yx.unicodeDecode()
        }
    }
}

extension String: LogContent {
    public var logStringValue: String {
        return self.yx.unicodeDecode()
    }
}
