# XEBox - Xcode source editor extension toolbox

XEBox is a collection of Xcode source editor extensions I made for swift coding, which including:
* Import for me
* Turn to NSLocalizedString
* Move up into braces
* Turn to optional binding

## Import for me
Type 'import #module#' or just even the module name in a new line and launch the extension, the module will be automatically imported to the head of file and leave you at where you are.

<img src=/images/screenshot-importForMe.gif width=600>

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

## How to use

1. Download the code
2. Open the project in Xcode 8.0 or later.
3. Resolve the code sign issues
4. Build and run.
5. You may need to enable the extension from  -> System Preferences -> Extensions -> Xcode Source Editor
6. You will find the command in the Editor Menu.