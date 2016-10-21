# XEBox - an Xcode source editor extension toolbox

[![Platform](https://img.shields.io/badge/xcode-8-blue.svg?style=flat)](https://developer.apple.com/xcode/)
[![Swift 3](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
[![Twitter](https://img.shields.io/badge/twitter-@robinlu-blue.svg?style=flat)](http://twitter.com/robinlu)

XEBox is a collection of Xcode source editor extensions I made for swift coding, which including:
* Import for me
* Turn to NSLocalizedString
* Move up into braces
* Turn to optional binding

## Turn to NSLocalizedString
Type a quoted string and turn it into the form of:
	NSLocalizedString(“string”, comment:”string”)

<img src=/images/screenshot-NSLocalizedString.gif width=600>

## Turn to optional binding
This one turns an “let” assignment into an optional binding.
<img src=/images/screenshot-optionalBinding.gif width=600>

## Move up into braces
This one moves the selected codes up into the nearest braces.
<img src=/images/screenshot-moveUpInBrace.gif width=600>

## Import for me
Type 'import #module#' or just even the module name in a new line and launch the extension, the module will be automatically imported to the head of file and leave you at where you are.

<img src=/images/screenshot-importForMe.gif width=600>

## How to use

1. Download the code
2. Open the project in Xcode 8.0 or later.
3. Resolve the code sign issues
4. Build and run.
5. You may need to enable the extension from  -> System Preferences -> Extensions -> Xcode Source Editor
6. You will find the command in the Editor Menu.

## Author
[Lu Yibin](http://robin.github.io)

## License
LYTabView is available under the MIT license. See the LICENSE file for more info.
