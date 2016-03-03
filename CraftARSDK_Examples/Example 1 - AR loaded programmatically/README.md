## AR loaded programmatically

This example shows how to load Augmented Reality contents 
programmatically on top of a reference image found using Cloud Recognition.

This project combines two features of the SDK: Cloud Image Recognition and Augmented Reality.

For the Cloud Image Recognition we used the Finder Mode search as 
explained in [this tutorial](http://support.catchoom.com/customer/en/portal/articles/1887576-tutorial-use-cloud-image-recognition-on-ios)

For Augmented reality we started with [this tutorial](http://support.catchoom.com/customer/en/portal/articles/1887500-tutorial-use-tracking-on-ios)
and added the following code to create some AR content programmatically from local resources:

```
// Local content creation
CraftARTrackingContentImage *image = [[CraftARTrackingContentImage alloc] initWithImageNamed:@"AR_programmatically_content" ofType:@"png"];
image.wrapMode = CRAFTAR_TRACKING_WRAP_ASPECT_FIT;
[arItem addContent:image];
```

We also implemented the tracking events and content events protocols in order to detect tracking event and touches on contents:

```
    // Get the instance of the SDK and become delegate, this will trigger
    // the content touch events if the protocol is implemented
    mSDK = [CraftARSDK sharedCraftARSDK];
    mSDK.delegate = self;

    // Get the tracking module and become delegate to receive tracking events
    mTracking = [CraftARTracking sharedTracking];
    mTracking.delegate = self;
```

```
// Using the CraftARTrackingEventsProtocol and becoming delegate of the CraftARTracking class,
// you can start receiving globally all tracking events produced by the SDK on the items added.

- (void) didStartTrackingItem:(CraftARItemAR *)item {
    NSLog(@"Start tracking: %@", item.name);
}

- (void) didStopTrackingItem:(CraftARItemAR *)item {
    NSLog(@"Stop tracking: %@", item.name);
}

// The CraftARContentEventsProtocol protocol allows to receive events for specific contents
// You can navigate to the parent item of a content using content.parentARItem
- (void) didGetTouchEvent:(CraftARContentTouchEvent)event forContent:(CraftARTrackingContent *)content {
    switch (event) {
        case CRAFTAR_CONTENT_TOUCH_IN:
            NSLog(@"Touch in: %@", content.uuid);
            break;
        case CRAFTAR_CONTENT_TOUCH_OUT:
            NSLog(@"Touch out: %@", content.uuid);
            break;
        case CRAFTAR_CONTENT_TOUCH_UP:
            NSLog(@"Touch up: %@", content.uuid);
            break;
        case CRAFTAR_CONTENT_TOUCH_DOWN:
            NSLog(@"Touch down: %@", content.uuid);
            break;
        default:
            break;
    }
}

```
