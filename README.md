# MXParallaxHeader

[![Travis (.com)](https://img.shields.io/travis/com/ngochiencse/MXParallaxHeader)](https://www.travis-ci.com/github/ngochiencse/MXParallaxHeader)
[![Version](https://img.shields.io/cocoapods/v/MXParallaxHeader)](http://cocoapods.org/pods/MXParallaxHeader)
[![Swift 5.4](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fngochiencse%2FMXParallaxHeader%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ngochiencse/MXParallaxHeader)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/MXParallaxHeader)](http://cocoapods.org/pods/MXParallaxHeader)
[![Cocoapods platforms](https://img.shields.io/cocoapods/p/MXParallaxHeader)](http://cocoapods.org/pods/MXParallaxHeader)

MXParallaxHeader is a Swift conversion from https://github.com/maxep/MXParallaxHeader.

MXParallaxHeader is a simple header class for UIScrollView.

In addition, MXScrollView is a UIScrollView subclass with the ability to hook the vertical scroll from its subviews, this can be used to add a parallax header to complex view hierachy. Moreover, MXScrollViewController allows you to add a MXParallaxHeader to any kind of UIViewController.

|             UIScrollView        |           MXScrollViewController          |
|---------------------------------|-------------------------------------------|
|![Demo](Example/demo1.gif)|![Demo](Example/demo2.gif)|

## Usage

If you want to try it, simply run:

```
pod try MXParallaxHeader
```

+ Adding a parallax header to a UIScrollView is straightforward, e.g:

```swift
let headerView = UIImageView()
headerView.image = UIImage(named: "success-baby")
headerView.contentMode = .scaleAspectFit

let scrollView = UIScrollView()
scrollView.parallaxHeader.view = headerView
scrollView.parallaxHeader.height = 150
scrollView.parallaxHeader.mode = .fill
scrollView.parallaxHeader.minimumHeight = 20
```

+ The MXScrollViewController is a container with a child view controller that can be added programmatically or using the custom segue MXScrollViewControllerSegue.

## Installation

### Swift Package Manager 

You can use  [Swift Package Manager](https://swift.org/package-manager/)  directly within Xcode or add it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/ngochiencse/MXParallaxHeader", .upToNextMajor(from: "1.1.8"))
]
```

### CocoaPods

MXParallaxHeader is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "MXParallaxHeader"
```

## Documentation

Documentation is available through [GitHub](https://ngochiencse.github.io/MXParallaxHeader/documentation/MXParallaxHeader).

## Author

[Hien Pham](https://github.com/ngochiencse)

![Twitter URL](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Fngochien91)

## License

MXParallaxHeader is available under the MIT license. See the LICENSE file for more info.
