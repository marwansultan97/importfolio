# SABlurImageView

[![Platform](http://img.shields.io/badge/platform-iOS%20|%20tvOS%20|%20macOS-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/Language-Swift-pink.svg?style=flat
)](https://developer.apple.com/swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-orange.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SwiftPM compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![Version](https://img.shields.io/cocoapods/v/SABlurImageView.svg?style=flat)](http://cocoapods.org/pods/SABlurImageView)
[![CocoaPods](https://img.shields.io/cocoapods/dt/SABlurImageView.svg)](https://cocoapods.org/?q=SABlurImageView)
[![License](https://img.shields.io/cocoapods/l/SABlurImageView.svg?style=flat)](http://cocoapods.org/pods/SABlurImageView)

![](./SampleImage/sample.gif)

You can use blur effect and it's animation easily to call only two methods.

[ManiacDev.com](https://maniacdev.com/) referred.  
[https://maniacdev.com/2015/04/open-source-ios-library-for-easily-adding-animated-blurunblur-effects-to-an-image](https://maniacdev.com/2015/04/open-source-ios-library-for-easily-adding-animated-blurunblur-effects-to-an-image)

## Features

- [x] Blur effect with box size
- [x] Blur animation
- [x] 0.0 to 1.0 parameter blur
- [x] Support Swift4

## Installation

#### CocoaPods

SABlurImageView is available through [CocoaPods](http://cocoapods.org). If you have cocoapods 0.38.0 or greater, you can install
it, simply add the following line to your Podfile:

    pod "SABlurImageView"

#### Carthage

If you’re using [Carthage](https://github.com/Carthage/Carthage), simply add
SABlurImageView to your `Cartfile`:

```
github "marty-suzuki/SABlurImageView"
```

Make sure to add `SABlurImageView.framework` to "Linked Frameworks and Libraries" and "copy-frameworks" Build Phases.

#### Swift Package Manager

If you’re using [Swift Package Manager](https://github.com/apple/swift-package-manager), simply add SABlurImageView to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/marty-suzuki/SABlurImageView", from: "0.1.0")
]
```

#### Manually

Add the [SABlurImageView](./SABlurImageView) directory to your project.

## Usage In Swift

To run the example project, clone the repo, and run `pod install` from the Example directory first.

If you install from pod, you have to write `import SABlurImageView`.

If you want to apply blur effect for image

```swift
let imageView = SABlurImageView(image: image)
imageView.addBlurEffect(30, times: 1)
```

If you want to animate

```swift
let imageView = SABlurImageView(image: image)
imageView.configrationForBlurAnimation()
imageView.startBlurAnimation(duration: 2.0)
```

First time of blur animation is normal to blur. Second time is blur to normal. (automatically set configration of reverse animation)

If you want to use 0.0 to 1.0 parameter

```swift
let imageView = SABlurImageView(image: image)
imageView.configrationForBlurAnimation(100)
imageView?.blur(0.5)
```

## Usage In Objective-C

You can use `SABlurImageView` in Objective-C!

If you install from pod, you have to write `#import <SABlurImageView/SABlurImageView-Swift.h>` in `.m`.

If you want to apply blur effect for image

```objc
SABlurImageView *imageView = [[SABlurImageView alloc] initWithImage:image];
[imageView addBlurEffect:30.0f times:1];
```

If you want to animate

```objc
SABlurImageView *imageView = [[SABlurImageView alloc] initWithImage:image];
[imageView configrationForBlurAnimation:100.0f];
[imageView startBlurAnimation:2.0f];
```

First time of blur animation is normal to blur. Second time is blur to normal. (automatically set configration of reverse animation)

If you want to use 0.0 to 1.0 parameter

```objc
SABlurImageView *imageView = [[SABlurImageView alloc] initWithImage:image];
[imageView configrationForBlurAnimation:100.0f];
[imageView blur:0.5f];
```

## Requirements

- Xcode 9.3 or greater
- iOS 8.0 or greater
- tvOS 9.0 or greater
- macOS 10.9 or greater
- QuartzCore
- Accelerate

## Author

Taiki Suzuki, s1180183@gmail.com

## License

SABlurImageView is available under the MIT license. See the LICENSE file for more info.
