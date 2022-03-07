//
//  YXSwiftKitUtil+UI.swift
//  YXSwiftKitUtil_Example
//
//  Created by Mr_Jesson on 2022/3/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

public enum YXSwiftKitUtilGradientDirection {
    case leftToRight            //AC - BD
    case topToBottom            //AB - CbD
    case leftTopToRightBottom   //A - D
    case leftBottomToRightTop   //C - B
}
//      A         B
//       _________b
//      |         |
//      |         |
//       ---------
//      C         D

public extension YXSwiftKitUtil {
    ///获取当前的normalwindow
    func getCurrentNormalWindow() -> UIWindow? {
        var window:UIWindow? = UIApplication.shared.keyWindow
        if #available(iOS 13.0, *) {
            for windowScene:UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                if windowScene.activationState == .foregroundActive {
                    window = windowScene.windows.first
                    for tmpWin in windowScene.windows {
                        if tmpWin.windowLevel == UIWindowLevelNormal {
                            window = tmpWin
                            break
                        }
                    }
                    break
                }
            }
        }
        if window == nil || window?.windowLevel != UIWindowLevelNormal {
            for tmpWin in UIApplication.shared.windows {
                if tmpWin.windowLevel == UIWindowLevelNormal {
                    window = tmpWin
                    break
                }
            }
        }
        return window
    }
    
    ///获取当前显示的vc
    func getCurrentVC(ignoreChildren: Bool = true) -> UIViewController? {
        let currentWindow = self.getCurrentNormalWindow()
        guard let window = currentWindow else { return nil }
        var vc: UIViewController?
        let frontView = window.subviews.first
        if let nextResponder = frontView?.next {
            if nextResponder is UIViewController {
                vc = nextResponder as? UIViewController
            } else {
                vc = window.rootViewController
            }
        } else {
            vc = window.rootViewController
        }
        
        while (vc is UINavigationController) || (vc is UITabBarController) {
            if vc is UITabBarController {
                let tabBarController = vc as! UITabBarController
                vc = tabBarController.selectedViewController
            } else if vc is UINavigationController {
                let navigationController = vc as! UINavigationController
                vc = navigationController.visibleViewController
            }
        }

        if !ignoreChildren, let children = vc?.childViewControllers, children.count > 0 {
            return children.last
        }
        return vc
    }
    
    ///通过颜色获取纯色图片
    func getImage(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var image: UIImage?
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        if let context = context {
            context.setFillColor(color.cgColor)
            context.fill(rect)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
    
    ///线性渐变
    func getLinearGradientImage(colors: [UIColor], directionType: YXSwiftKitUtilGradientDirection, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        if (colors.count == 0) {
            return UIImage()
        } else if (colors.count == 1) {
            return self.getImage(color: colors.first!)
        }
        let gradientLayer = CAGradientLayer()
        var cgColors = [CGColor]()
        var locations = [NSNumber]()
        for i in 0..<colors.count {
            let color = colors[i]
            cgColors.append(color.cgColor)
            let location = Float(i)/Float(colors.count - 1)
            locations.append(NSNumber(value: location))
        }
        
        gradientLayer.colors = cgColors
        gradientLayer.locations = locations
        
        if (directionType == .leftToRight) {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        } else if (directionType == .topToBottom){
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        } else if (directionType == .leftTopToRightBottom){
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        } else if (directionType == .leftBottomToRightTop){
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, false, 0)
        var gradientImage: UIImage?
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        if let context = context {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return gradientImage ?? UIImage()
    }
    
    ///角度渐变
    func getRadialGradientImage(colors: [UIColor], raduis: CGFloat, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        if (colors.count == 0) {
            return UIImage()
        } else if (colors.count == 1) {
            return self.getImage(color: colors.first!)
        }
        
        UIGraphicsBeginImageContext(size);
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: size.width/2.0, y: size.height / 2.0), radius: raduis, startAngle: 0, endAngle: CGFloat(Double.pi) * 2, clockwise: false)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var cgColors = [CGColor]()
        var locations = [CGFloat]()
        for i in 0..<colors.count {
            let color = colors[i]
            cgColors.append(color.cgColor)
            let location = Float(i)/Float(colors.count - 1)
            locations.append(CGFloat(location))
        }
        
        let colorGradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: locations)
        guard let gradient = colorGradient else { return UIImage() }
        
        let pathRect = path.boundingBox;
        let center = CGPoint(x: pathRect.midX, y: pathRect.midY)
        
        let currentContext: CGContext? = UIGraphicsGetCurrentContext()
        guard let context = currentContext else {
            return UIImage()
        }
        context.saveGState();
        context.addPath(path);
        context.clip()
        context.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: raduis, options: .drawsBeforeStartLocation);
        context.restoreGState();
        
        //        CGGradientRelease(gradient);
        //        CGColorSpaceRelease(colorSpace);
        //
        //        CGPathRelease(path);
        
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img ?? UIImage()
    }
}

///高度坐标配置
public var UIScreenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}
public var UIScreenHeight: CGFloat {
    return UIScreen.main.bounds.size.height
}

///状态栏高度
public var YXSwiftKitUtil_StatusBar_Height: CGFloat {
    return UIApplication.shared.statusBarFrame.size.height
}

///导航栏高度
public func YXSwiftKitUtil_Default_NavigationBar_Height(vc: UIViewController? = nil) -> CGFloat {
    if let navigationController = vc?.navigationController {
        return navigationController.navigationBar.frame.size.height
    } else {
        return UINavigationController(nibName: nil, bundle: nil).navigationBar.frame.size.height
    }
}

///tabbar高度
public func YXSwiftKitUtil_Default_Tabbar_Height(vc: UIViewController? = nil) -> CGFloat {
    if let tabbarViewController = vc?.tabBarController {
        return tabbarViewController.tabBar.frame.size.height
    } else {
        return UITabBarController(nibName: nil, bundle: nil).tabBar.frame.size.height
    }
}

///状态栏和导航栏总高度
public func YXSwiftKitUtil_Default_Nav_And_Status_Height(vc: UIViewController? = nil) -> CGFloat {
    return YXSwiftKitUtil_Default_NavigationBar_Height(vc: vc) + YXSwiftKitUtil_StatusBar_Height
}