# MoMo EKYC iOS SDK v1.0.0

## Introduction

The MoMo EKYC iOS SDK enables you to integrate MoMo EKYC into your iOS app. We also have an [Android SDK](https://github.com/MomoEkyc/android).

## **Installation**

Integration with your app is supported via CocoaPods and Swift Package Manager. You can also install the SDK manually in Xcode without the use of any dependency manager (this is not recommended). We recommend CocoaPods for the easiest and most flexible installation.

### CocoaPods

> **Note**: The SDK is distributed as an XCFramework, therefore **you are required to use CocoaPods 1.9.0 or newer**.

1. If you are not yet using CocoaPods in your project, first run `sudo gem install cocoapods` followed by `pod init`. (For further information on installing CocoaPods, [click here](https://guides.cocoapods.org/using/getting-started.html#installation).)

2. Add the following to your Podfile (inside the target section):

	```ruby
	pod 'MomoEkycSDK', :git => 'https://github.com/MomoEkyc/ios.git'
	```

3. Run `pod install`.

### Swift Package Manager

#### Installing via Xcode

1. Select `File` → `Add Packages…` in the Xcode menu bar.

2. Search for the MoMo EKYC SDK package using the following URL:

	```
	https://github.com/MomoEkyc/ios
	```
	
3. Set the _Dependency Rule_ to be _Up to Next Major Version_ and input 1.0.0 as the lower bound.
	
3. Click _Add Package_ to add the MoMo EKYC SDK to your Xcode project and then click again to confirm.

#### Installing via Package.swift

If you prefer, you can add MoMo EKYC via your Package.swift file as follows:

```swift
.package(
	name: "MomoEkycSDK",
	url: "https://github.com/MomoEkyc/ios.git",
	.upToNextMajor(from: "1.0.0")
),
```

Then add `MomoEkycSDK` to the `dependencies` array of any target for which you wish to use MoMo EKYC.

### Manual Installation

1. Select your project in Xcode.

2. Select your app target.

3. Select the **General** tab and then scroll down to **Frameworks, Libraries, and Embedded Content**.

4. Add `MomoEkycSDK.xcframework` from the [release assets](https://github.com/MomoEkyc/ios/releases/tag).

	> **Note**: Ensure you add the .xcframework file, rather than the .framework file.

5. Under the **Embed** column, ensure **Embed & Sign** is set.

----

### Add an `NSCameraUsageDescription`

All iOS apps which require camera access must request permission from the user, and specify this information in the Info plist.

Add an `NSCameraUsageDescription` entry to your app's Info.plist, with the reason why your app requires camera access (eg. “To MoMo EKYC you in order to verify your identity.”)

## Get Started

TBU

### Launch the SDK

Once you have obtained a token, you can simply call `MoMoEKYC.launch()`:

```swift
import MomoEkycSDK

let momoEkyc = MomoEKYC()
let token = "{{ your token here }}"
var sessionStateJob: AnyCancellable? = nil
let session = momoEkyc.launch(token: "", options: options)
sessionStateJob = momoEkyc.sessionState.$value.sink(receiveValue: { sessionState  in
	if sessionState?.uuid == session.uuid {
		self.observeState(sessionState!)
	}
})

private func observeState(_ sessionState: MomoEKYC.Session) {
	switch session.state {
	case .starting:
		// The SDK initializing
	case .connecting:
		// TBU
	case .connected:
		// The SDK has connected, and the MoMo EKYC user interface will now be displayed. You should hide
		// any progress indication at this point.
	case let .processing(progress):
		// The SDK will update your app with the progress of scan
		// This will be called multiple times as the progress updates.
	case let .success(result):
		// The user was successfully verified and the data has been validated.
		// You can access the following properties:
		let imageData: String = result.data // base64|encrypted_data
	case let .failure(errorCode, errorMessage):
		// The user was not successfully verified, as their identity could not be verified,
		// or there was another issue with their verification.
		// You can access the following properties:
		let reason: FailureReason = result.reason // A reason of why the claim failed
		// TBU
	case .canceled:
		// Either:
		//
		// (a) The user canceled MoMo EKYC by pressing the back button, or sending the
		// app to the background (canceler will be .user), or
		//
		// (b) You canceled MoMo EKYC by calling cancel() on the SDK (canceler will be .integration) - see cancelation below.
	case let .error(error):
		// The user was not successfully verified due to an error (e.g. exception)
		// along with an `Error` with more information about the error (NSError in Objective-C).
		// It will be called once, or never.
	}
}
```

### Canceling the SDK
To cancel the MoMo EKYC SDK, you first need to hold a reference to the MoMoEKYC session (returned from `MoMoEKYC.launch()`) and you can then call `cancel()` on it.

```swift
let momoEkyc = MomoEKYC()
let session = momoEkyc.launch(...)

DispatchQueue.main.asyncAfter(deadline: .now() + 10) { // Example - cancel the session after 10 sec
    session.clearSession() // Will return true if the session was successfully cleared
}
```

## Options

You can customize the MoMoEKYC session by passing in an `MomoEKYC.Options` reference when launching MoMoEKYC and setting any of these values:

| Option Name | Description | Default Value |
| --- | --- | --- |
| `flow` | The MoMo EKYC SDK will launch the corresponding flow. [See below for further detail](#flow-options). | `MomoEKYC.Flow.face` |
| `backgroundColor`| Background color.| `nil` |
| `tintColor` | Tint color. | `nil` |
| `font`  | Name of the font to be used for the title & prompt. | `"HelveticaNeue-Medium"` |
| `logoImage`  | Logo to be placed next to the title. | `nil` |

### Flow Options

The SDK supports three different flow:

#### `face`

The MoMo EKYC SDK will launch verify Face flow.

Example:

```swift
options.flow = MomoEKYC.Flow.face
```

#### `idCard`

The MoMo EKYC SDK will launch verify ID Card flow.

Example:

```swift
options.flow = MomoEKYC.Flow.idCard
```

#### `nfc`

The MoMo EKYC SDK will launch verify NFC flow.

Example:

```swift
options.flow = MomoEKYC.Flow.nfc
```

### String Localization & Customization

The SDK ships with support for the following languages:
| Language                | Code    |
|-------------------------|---------|
| English (United States) | `en-US` |
| Vietnamese              | `vi`    |

You can customize the strings in the app or localize them into a different language,

All strings are prefixed with `momo__` and you can override them in `Localizable.strings`.
