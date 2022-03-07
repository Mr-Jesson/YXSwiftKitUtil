//
//  YXKitNameSpace.swift
//  YXSwiftKitUtil_Example
//
//  Created by Mr_Jesson on 2022/3/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

//实现命名空间需遵守的协议
public protocol YXSwiftKitUtilNameSpaceWrappable {
    associatedtype WrapperType
    var yx: WrapperType { get }
    static var yx: WrapperType.Type { get }
}

public struct YXSwiftKitUtilNameSpace <T> {
    let object: T       //存储的实例对象
    static var classObject: T.Type {
        return T.self
    }
    internal init(object: T) {
        self.object = object
    }
}

//协议默认的实现方式
public extension YXSwiftKitUtilNameSpaceWrappable {
    var yx: YXSwiftKitUtilNameSpace<Self> {
        return YXSwiftKitUtilNameSpace(object: self)
    }

    static var yx: YXSwiftKitUtilNameSpace<Self>.Type {
        return YXSwiftKitUtilNameSpace.self
    }
}
