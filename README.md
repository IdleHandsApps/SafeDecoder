<p align="center">
<img alt="SafeDecoder" src="https://github.com/IdleHandsApps/StatusBarOverlay/blob/master/StatusBarOverlay/StatusBarOverlay/StatusBarOverlay/Assets.xcassets/AppIcon.appiconset/Logo-76.png" />
</p>


# SafeDecoder
A Codable helper to decode arrays and catches all decoding issues 



SafeDecoder [![Language: Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg)](https://swift.org)
------------------------------

SafeDecoder makes two improvements for Codable models. When decoding arrays it can skip over a invalid item, allowing your app to show all the valid items. It can also collect all the decoding errors and send them to your logging class or service

## Features

* Just a few lines of code and StatusBarOverlay will automatically show & hide when internet connection is lost & regained
* Support for apps that hide the status bar permanently
* Support for the iPhone X Notch
* Optionally you can choose to show the status bar anytime with custom text, eg for Debug or Demo modes
* Optionally you can show a drop down message, below the status bar, with a click handle, great for nonintrusive alerts
* Fully customisable colors & text

## How to install

Add this to your CocoaPods Podfile
```
pod 'SafeDecoder'
```

## How to use

To decode arrays safely, in you model's init(from decoder:) just call container.decodeArray() and pass in the model type in your array
```swift
import SafeDecoder

struct MyModel: Decodable {

var myArray: [CGRect]

enum CodingKeys: String, CodingKey {
case myArray
}

public init(from decoder: Decoder) throws {
let container = try decoder.container(keyedBy: CodingKeys.self)

// to parse an array without re-thowing an error, call decodeArray()
myArray = try container.decodeArray(CGRect.self, forKey: .myArray)
}
}
```

To collect all decoding errors for logging, first, implement your own logging here
```swift
SafeDecoder.logger = { error, typeName in

// replace with a call to your own logging service
print(error)
}
```
Then in you model's init(from decoder:) call decoder.safeContainer(), then call container.decodeSafe() or container.decodeArraySafe()
```swift
import SafeDecoder

struct MyModel: Decodable {

var myId: String
var myArray: [CGRect]

enum CodingKeys: String, CodingKey {
case myId
case myArray
}

public init(from decoder: Decoder) throws {
var container = try decoder.safeContainer(keyedBy: CodingKeys.self)

let _myId = try container.decodeSafe(String.self, forKey: .myId)
let _myArray = try container.decodeArraySafe(CGRect.self, forKey: .myArray)

guard
let myId = _myId,
let myArray = _myArray
else {
// the reference can be your object identifier to help find the issue with your data
throw container.getErrors(modelType: MyModel.self, reference: _myId)
}

self.myId = myId
self.myArray = myArray
}
}
```

## Get these while stocks last :)

An elegant solution for keeping views visible when the keyboard is being shown
https://github.com/IdleHandsApps/IHKeyboardAvoiding

Button styles that are centralied and reusable, and hooked up to InterfaceBuilder
https://github.com/IdleHandsApps/DesignableButton

An extension to easily set your UINavigationBar transparent and hide the shadow
https://github.com/IdleHandsApps/UINavigationBar-Transparent

## Author

* Fraser Scott-Morrison (fraserscottmorrison@me.com)

It'd be great to hear about any cool apps that are using StatusBarOverlay

## License

Distributed under the MIT License
