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


#import "AR_ProgrammaticallyViewController.h"
#import <CraftARAugmentedRealitySDK/CraftARSDK.h>
#import <CraftARAugmentedRealitySDK/CraftARCloudRecognition.h>
#import <CraftARAugmentedRealitySDK/CraftARTracking.h>
#import <CraftARAugmentedRealitySDK/CraftARTrackingContentImage.h>

@interface AR_ProgrammaticallyViewController ()<CraftARSDKProtocol, CraftARContentEventsProtocol, SearchProtocol, CraftARTrackingEventsProtocol> {
    CraftARSDK *mSDK;
    CraftARCloudRecognition *mCloudRecognition;
    CraftARTracking* mTracking;
}
@end

@implementation AR_ProgrammaticallyViewController

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
    mSDK = [CraftARSDK sharedCraftARSDK];
    mSDK.delegate = self;
    
    // Get the Cloud recognition module and set 'self' as delegate to receive the SearchProtocol callbacks
    mCloudRecognition = [CraftARCloudRecognition sharedCloudImageRecognition];
    mCloudRecognition.delegate = self;
    
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
    [super viewWillDisappear:animated];
}

#pragma mark -


#pragma mark Finder mode AR implementation

- (void) didStartCapture {
    
    // The SDK manages the Single shot search and the Finder Mode search, the cloud recognition's
    // search controller is the delegate for doing the searches.
    // This needs to be done after the camera initialization
    mSDK.searchControllerDelegate = mCloudRecognition.mSearchController;
    
    // Set the colleciton we will search using the token.
    __block AR_ProgrammaticallyViewController* mySelf = self;
    [mCloudRecognition setCollectionWithToken:@"augmentedreality" onSuccess:^{
        NSLog(@"Ready to search!");
        mySelf._scanOverlay.hidden = false;
        
        // The Search methods (Single shot search and Finder Mode) are controlled by
        // the SDK. The searchControllerDelegate will receive the camera events and search
        // with the picture or image frames coming from the camera.
        [[CraftARSDK sharedCraftARSDK] startFinder];
    } andOnError:^(NSError *error) {
        NSLog(@"Error setting token: %@", error.localizedDescription);
    }];
}

- (void) didGetSearchResults:(NSArray *)results {
    
    bool haveARItems = NO;
    
    if ([results count] >= 1) {
        [mSDK stopFinder];
        // Found one result, launch its content on a webView:
        CraftARSearchResult *result = [results objectAtIndex:0];
        
        // Each result has one item
        CraftARItem* item = result.item;
        
        if ([item isKindOfClass:[CraftARItemAR class]]) {
            CraftARItemAR* arItem = (CraftARItemAR*)item;
            
            // Local content creation
            CraftARTrackingContentImage *image = [[CraftARTrackingContentImage alloc] initWithImageNamed:@"AR_programmatically_content" ofType:@"png"];
            image.wrapMode = CRAFTAR_TRACKING_WRAP_ASPECT_FIT;
            [arItem addContent:image];
            
            NSError *err = [mTracking addARItem:arItem];
            if (err) {
                NSLog(@"Error adding AR item: %@", err.localizedDescription);
            }
            haveARItems = YES;
        }
        if (haveARItems) {
            self._scanOverlay.hidden = YES;
            [mTracking startTracking];
        } else {
            [mSDK startFinder];
        }
    }
}

- (void) didFailSearchWithError:(NSError *)error {
    // Check the error type
    NSLog(@"Error calling CRS: %@", [error localizedDescription]);
}

#pragma mark -

#pragma mark Receive Tracking and contents events

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


#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
