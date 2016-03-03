## CraftAR - iOS SDK examples

### Introduction

CraftAR allows to create recognition only and Augmented Reality (AR)
experiences using the CraftAR Service and its Mobile SDK (‘Mobile SDK’).

With CraftAR, you can create amazing apps that provide digital content
for real-life objects like printed media, packaging among others. You
can use our online web panel or APIs, to upload images to be recognised and set
AR content to display upon recognition in your CraftAR-powered
app.

### How to use the examples

This repository contains the project files and source code of some examples
that show how to use the CraftAR Augmented Reality SDK.

The examples **are included in the SDK distribution with the SDK already linked to
the project**. The best way to use the examples is to [download the SDK](http://catchoom.com/documentation/image-recognition-sdk/ios-image-recognition-sdk/), open the xCode
project and hit the run button.


### Examples
This project includes 4 examples showing different ways of using the SDK:

##### [AR Loaded Programmatically](CraftARSDK_Examples/Example%201%20-%20AR%20loaded%20programmatically)
This example shows how to load Augmented Reality contents programmatically on top of a reference image
found using Cloud Recognition.

##### [AR from CraftAR](CraftARSDK_Examples/Example%202%20-%20AR%20from%20CraftAR)
This example shows how the SDK is able to load AR contents automatically from a scene created using the
CraftAR Creator.

##### [Cloud Image Recognition](Example%203%20-%20Recognition%20only)
In this example we show that the AR SDK can also be used to find Image Recognition items
and perform actions upon detection of a non-AR item.

##### [On-device Augmented Reality](Example%204%20-%20On-device%20Augmented%20Reality)
This example shows how to add a collection of AR items locally into the device and load
them to start an Augmented Reality experience.

### Requirements

To build the project or use the library, you will need XCode 7 or newer,
and at least the iOS 9.0 SDK.

This example works with the Catchoom SDK version 4. If you have an earlier version (3), you can still find the examples in [this branch](https://github.com/Catchoom/craftar-example-ios/tree/sdk-v3).


### Integrate the SDK in your own project

Follow [this tutorial](http://support.catchoom.com/customer/portal/articles/1887554-tutorial-set-up-the-ios-project-in-xcode) for instructions in how to integrate the SDK in your xCode projects.

