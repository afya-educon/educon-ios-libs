//
//  UIScrollView+ParallaxHeader.swift
//  MXParallaxHeader
//
//  Created by Hien Pham on 22/05/2021.
//

import UIKit

private var parallaxHeaderKey: UInt8 = 0
public extension UIScrollView {
    @IBOutlet var parallaxHeader: MXParallaxHeader! {
        get {
            let value = objc_getAssociatedObject(self, &parallaxHeaderKey) as? MXParallaxHeader;
            if let unwrapped = value {
                return unwrapped
            } else {
                let newValue = MXParallaxHeader()
                self.parallaxHeader = newValue
                return newValue
            }
        }
        set {
            newValue.scrollView = self
            objc_setAssociatedObject(self, &parallaxHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
