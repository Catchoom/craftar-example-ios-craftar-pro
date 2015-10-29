## CraftAR - iOS SDK examples

### Introduction

CraftAR allows to create recognition only and Augmented Reality (AR)
experiences using the CraftAR Service and its Mobile SDK (‘Mobile SDK’).

With CraftAR, you can create amazing apps that provide digital content
for real-life objects like printed media, packaging among others. You
can use our online web panel or APIs, to upload images to be recognised and set
AR content to display upon recognition in your CraftAR-powered
app.

This document describes mainly the Examples of different uses of the Service and the SDK.
General use of the SDK can be found in the [Documentation section of Catchoom website](http://catchoom.com/documentation/sdk/ios/). Complete SDK documentation of the
classes can be found within the SDK distribution.

### How to use the examples

This repository comes with an xCode project of an iOS app with several
examples that show how to use the SDK.

To run the examples follow these steps:
 1.  Open the CraftARSDK_Examples.xcodeproj project.
 2.  Integrate the CraftARSDK into the xCode project (see [below](#step-by-step-guide)).
 3.  Select an iOS 7+ device (notice that the project will not
     compile for the simulator).
 4.  Hit the run button.


### Add CraftARSDK to the Example project

#### Requirements

To build the project or use the library, you will need XCode 7 or newer,
and at least the iOS 9.0 SDK.

This example works with the Catchoom SDK version 4. If you have an earlier version (3), you can still find the examples in [this branch](https://github.com/Catchoom/craftar-example-ios/tree/sdk-v3).

#### Step-by-step guide
1.  Download the [CraftAR SDK](http://catchoom.com/product/mobile-sdk/) for iOS.
2.  Unzip the package
3.  Using Finder, drag the following files into the project in ExternalFrameworks directory:
 * CraftARAugmentedRealitySDK.framework
 * CraftARResourcesAR.bundle
 * Pods.framework
 
 
#### Advanced configuration

The Pods.framework provided with the SDK, contains the Pods dependencies used in the CraftARSDK. If you are using cocoa pods in your project, you can remove the framework and add the dependencies to your *Podfile* this is how ours looks like:

```
workspace 'catchoom-sdk-workspace'
platform :ios, '7.1'
pod 'AFDownloadRequestOperation', '2.0.1'
```
