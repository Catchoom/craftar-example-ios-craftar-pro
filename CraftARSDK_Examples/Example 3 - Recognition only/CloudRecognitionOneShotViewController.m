//
//  CloudRecognitionSnapPhotoViewController.m
//
//  Created by Luis Martinell Andreu on 9/17/13.
//  Copyright (c) 2013 Catchoom. All rights reserved.
//

#import "CloudRecognitionOneShotViewController.h"
#import <CraftARPRoSDK/CraftARSDK.h>
#import <CraftARPRoSDK/CraftAROnDeviceIR.h>


@interface CloudRecognitionOneShotViewController () <CraftARSDKProtocol, CraftARContentEventsProtocol, SearchProtocol> {
    CraftARSDK *mSDK;
    CraftAROnDeviceIR *mOnDeviceIR;
}

@end

@implementation CloudRecognitionOneShotViewController

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
    mOnDeviceIR = [CraftAROnDeviceIR sharedCraftAROnDeviceIR];
    mOnDeviceIR.delegate = self;
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    // Start the camera capture to be able to perform Single Shot searches
    [mSDK startCaptureWithView:self._preview];
}

- (void) viewWillDisappear:(BOOL)animated {
    // stop the capture when the view is disappearing. This releases the camera resources.
    [mSDK stopCapture];
    [super viewWillDisappear:animated];
}

#pragma mark -


#pragma mark Snap Photo mode implementation

- (void) didStartCapture {
    self._previewOverlay.hidden = NO;
    
    // The SDK manages the Single shot search and the Finder Mode search, the cloud recognition's
    // search controller is the delegate for doing the searches.
    // This needs to be done after the camera initialization
    mSDK.searchControllerDelegate = mOnDeviceIR.mSearchController;
    
    NSLog(@"Ready to search!");
}

- (IBAction)snapPhotoToSearch:(id)sender {
    self._previewOverlay.hidden = YES;
    self._scanningOverlay.hidden = NO;
    [self._scanningOverlay setNeedsDisplay];
    
    // The Search methods (Single shot search and Finder Mode) are controlled by
    // the SDK. The searchControllerDelegate will receive the camera events and search
    // with the picture or image frames coming from the camera.
    [mSDK singleShotSearch];
    
}

- (void) didGetSearchResults:(NSArray *)results {
    self._scanningOverlay.hidden = YES;
    
    if ([results count] >= 1) {
        // Found one result, launch its content on a webView:
        CraftARSearchResult *result = [results objectAtIndex:0];
        
        // Each result has one item
        CraftARItem* item = result.item;
        
        // Open URL in Webview
        UIViewController *webViewController = [[UIViewController alloc] init];
        UIWebView *uiWebView = [[UIWebView alloc] initWithFrame: self.view.frame];
        [uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:item.url]]];
        uiWebView.scalesPageToFit = YES;
        [webViewController.view addSubview: uiWebView];
        [self.navigationController pushViewController:webViewController animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Nothing found"];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"Ok"];
        [alert show];
    }
    
    // The single shot search freezes the capture, restart it now
    self._previewOverlay.hidden = NO;
    self._scanningOverlay.hidden = YES;
    [[mSDK getCamera] restartCapture];
}

- (void) didFailSearchWithError:(NSError *)error {
    // Check the error type
    NSLog(@"Error calling CRS: %@", [error localizedDescription]);
    self._previewOverlay.hidden = NO;
    self._scanningOverlay.hidden = YES;
    // The single shot search freezes the capture, restart it now
    [[mSDK getCamera] restartCapture];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
