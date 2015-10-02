// CraftARSDK_Examples is free software. You may use it under the MIT license, which is copied
// below and available at http://opensource.org/licenses/MIT
//
// Copyright (c) 2014 Catchoom Technologies S.L.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
// Software, and to permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.


#import "On-Device_Augmented_Reality.h"

#import <CraftARAugmentedRealitySDK/CraftARSDK_AR.h>
#import <CraftARAugmentedRealitySDK/CraftARCollectionManager.h>
#import <CraftARAugmentedRealitySDK/CraftARTracking.h>

@interface OnDeviceAugmentedReality () <CraftARSDKProtocol, CraftARContentEventsProtocol, CraftARTrackingEventsProtocol> {
    CraftARSDK_AR *mSDK;
    CraftARCollectionManager* mCollectionManager;
    CraftAROnDeviceCollection* mARCollection;
    CraftARTracking* mTracking;
}
@end

@implementation OnDeviceAugmentedReality

#pragma mark view initialization and events

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get the instance of the SDK and become delegate
    mSDK = [CraftARSDK_AR sharedCraftARSDK_AR];
    mSDK.delegate = self;
    
    // Get the tracking module and become delegate to receive tracking events
    mTracking = [CraftARTracking sharedTracking];
    mTracking.delegate = self;
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    // Start the camera capture to be able to perform Single Shot searches
    [mSDK startCaptureWithView:self.videoPreviewView];
}

- (void) viewWillDisappear:(BOOL)animated {
    // stop the capture when the view is disappearing. This releases the camera resources.
    [mSDK stopCapture];
    // Remove all items from the Tracking when leaving the view.
    [mTracking removeAllARItems];
    [super viewWillDisappear:animated];
}

#pragma mark -


#pragma mark On-device AR implementation

- (void) didStartCapture {
    __block OnDeviceAugmentedReality* mySelf = self;
    
    
    // The collection manager allows to manage on-device collections
    mCollectionManager = [CraftARCollectionManager sharedCollectionManager];
    
    // In this case, we downloaded an on-device Bundle
    NSString* bundle = [[NSBundle mainBundle] pathForResource:@"8d4fc8ab15a94ad981234925f85498d2" ofType:@"zip"];
    
    // We add the on-device bundle to the collection manager
    [mCollectionManager addCollectionFromBundle:bundle withOnProgress:^(float progress) {
        NSLog(@"Progress: %f", progress);
    } andOnSuccess:^(CraftAROnDeviceCollection *collection) {
        mARCollection = collection;
        // Ready to retrieve and Add AR items to the tracking, for now, just do it after 1 second
        //[mySelf performSelector:@selector(startOfflineARTracking) withObject:mySelf afterDelay:1];
        [mySelf startOfflineARTracking];
    } andOnError:^(CraftARError *error) {
        NSLog(@"Error adding bundle %@", error.localizedDescription);
    }];
}

- (void) startOfflineARTracking {
    NSError* error;
    CraftARItemAR* arItem = (CraftARItemAR*)[mARCollection getItem:@"e11fbe6e9cf342ec950cac6e0f4c5cff" andError:&error];
    if (error != nil) {
        NSLog(@"Error getting item: %@", error.localizedDescription);
    } else {
        [mTracking addARItem:arItem];
        [mTracking startTrackingWithTimeout: 15.0];
    }
}

- (void) trackingTimeoutOver {
    NSLog(@"TRACKING TIMEOUT OVER!!");
}

#pragma mark -

#pragma mark Receive Tracking and contents events

// Using the CraftARTrackingEventsProtocol and becoming delegate of the CraftARTracking class,
// you can start receiving globally all tracking events produced by the SDK on the items added.

- (void) didStartTrackingItem:(CraftARItemAR *)item {
    NSLog(@"Start tracking: %@", item.name);
    self._scanOverlay.hidden = YES;
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


#pragma mark -
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
