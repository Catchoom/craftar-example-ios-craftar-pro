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

#import "MainScreenViewController.h"
#import <CraftAROnDeviceIRandARSDK/CraftARCollectionManager.h>
#import <CraftAROnDeviceIRandARSDK/CraftAROnDeviceIR.h>

@interface MainScreenViewController () {
    CraftARCollectionManager* mCollectionManager;
    CraftAROnDeviceIR* mOnDeviceIR;
}

@end

@implementation MainScreenViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self loadOnDeviceCollection];
    
}


- (void) loadOnDeviceCollection {
    __block MainScreenViewController* mySelf = self;
    
    // The collection manager allows to manage on-device collections
    mCollectionManager = [CraftARCollectionManager sharedCollectionManager];
    
    // In this case, we downloaded an on-device Bundle
    NSString* bundle = [[NSBundle mainBundle] pathForResource:@"augmentedreality" ofType:@"zip"];
    
    // We add the on-device bundle to the collection manager
    [mCollectionManager addCollectionFromBundle:bundle withOnProgress:^(float progress) {
        NSLog(@"Add collection to device progress: %f", progress);
    } andOnSuccess:^(CraftAROnDeviceCollection *collection) {
        [mySelf addCollectionForOnDeviceIR:collection];
    } andOnError:^(CraftARError *error) {
        NSLog(@"Error adding bundle %@", error.localizedDescription);
    }];
}

- (void) addCollectionForOnDeviceIR: (CraftAROnDeviceCollection*) collection {
    mOnDeviceIR = [CraftAROnDeviceIR sharedCraftAROnDeviceIR];
    [mOnDeviceIR setCollection:(CraftAROnDeviceCollection *) collection withOnProgress:^(float progress) {
        NSLog(@"Load collection for on-device IR progress: %f", progress);
    } onSuccess:^{
        NSLog(@"Ready for On-device IR");
    } andOnError:^(NSError *error) {
        NSLog(@"Error loading on-device collection for IR: %@", error.localizedDescription);
    }];
}

- (IBAction)buttonPressed:(id)sender {
    UIViewController *target;
    if (sender == self._helloWorldButton) {
        UIStoryboard *exampleStoryBoard = [UIStoryboard storyboardWithName:@"AR_Programmatically" bundle:nil];
        target = (UIViewController *)[exampleStoryBoard instantiateViewControllerWithIdentifier:@"AR_ProgrammaticallyViewController"];
        target.navigationItem.title = @"AR programmatically";
    } else if (sender == self._contentCreationButton) {
        UIStoryboard *exampleStoryBoard = [UIStoryboard storyboardWithName:@"AR_fromCraftAR" bundle:nil];
        target = (UIViewController *)[exampleStoryBoard instantiateViewControllerWithIdentifier:@"AR_fromCraftARViewController"];
        target.navigationItem.title = @"AR from CraftAR";
    } else if (sender == self._recognitionOnlyButton) {
        UIStoryboard *exampleStoryBoard = [UIStoryboard storyboardWithName:@"CloudRecognition" bundle:nil];
        target = (UIViewController *)[exampleStoryBoard instantiateViewControllerWithIdentifier:@"CloudRecognitionOneShotViewController"];
        target.navigationItem.title = @"Recognition Only";
    } else if (sender == self._onDeviceAR) {
        UIStoryboard *exampleStoryBoard = [UIStoryboard storyboardWithName:@"On-device_Augmented_Reality" bundle:nil];
        target = (UIViewController *)[exampleStoryBoard instantiateViewControllerWithIdentifier:@"OnDeviceAugmentedReality"];
        target.navigationItem.title = @"On-device AR";
    }
    [self.navigationController pushViewController:target animated:YES];
}


#pragma Websites with outside content
NSString* utm_medium = @"iOS";
NSString* utm_source = @"CraftARExamplesApp";


- (IBAction)signUpURL:(id)sender {
    NSMutableString *urlString = [[NSMutableString alloc] initWithString: @"https://crs.catchoom.com/try-free?utm_source="];
    [urlString appendString:utm_source];
    [urlString appendString:@"&utm_medium="];
    [urlString appendString:utm_medium];
    [urlString appendString:@"&utm_campaign=SignUp"];
    
    // Open URL in Webview
    UIViewController *webViewController = [[UIViewController alloc] init];
    
    UIWebView *uiWebView = [[UIWebView alloc] initWithFrame: self.view.frame];
    [uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    uiWebView.scalesPageToFit = YES;
    
    [webViewController.view addSubview: uiWebView];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)craftARProductURL:(id)sender {
    NSMutableString *urlString = [[NSMutableString alloc] initWithString: @"http://catchoom.com/product/?utm_source="];
    [urlString appendString:utm_source];
    [urlString appendString:@"&utm_medium="];
    [urlString appendString:utm_medium];
    [urlString appendString:@"&utm_campaign=HelpWithAPI"];
    
    // Open URL in Webview
    UIViewController *webViewController = [[UIViewController alloc] init];
    
    UIWebView *uiWebView = [[UIWebView alloc] initWithFrame: self.view.frame];
    [uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    uiWebView.scalesPageToFit = YES;
    
    [webViewController.view addSubview: uiWebView];
    [self.navigationController pushViewController:webViewController animated:YES];
}


- (IBAction)launchAPIURL:(id)sender {
    NSMutableString *urlString = [[NSMutableString alloc] initWithString: @"http://catchoom.com/documentation/api/management?utm_source="];
    [urlString appendString:utm_source];
    [urlString appendString:@"&utm_medium="];
    [urlString appendString:utm_medium];
    [urlString appendString:@"&utm_campaign=HelpWithAPI"];
    
    // Open URL in Webview
    UIViewController *webViewController = [[UIViewController alloc] init];
    
    UIWebView *uiWebView = [[UIWebView alloc] initWithFrame: self.view.frame];
    [uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    uiWebView.scalesPageToFit = YES;
    
    [webViewController.view addSubview: uiWebView];
    [self.navigationController pushViewController:webViewController animated:YES];
    
}

- (IBAction)launchCRSURL:(id)sender {
    NSMutableString *urlString = [[NSMutableString alloc] initWithString: @"http://crs.catchoom.com?utm_source="];
    [urlString appendString:utm_source];
    [urlString appendString:@"&utm_medium="];
    [urlString appendString:utm_medium];
    [urlString appendString:@"&utm_campaign=HelpWithAPI"];
    
    // Open URL in Webview
    UIViewController *webViewController = [[UIViewController alloc] init];
    
    UIWebView *uiWebView = [[UIWebView alloc] initWithFrame: self.view.frame];
    [uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    uiWebView.scalesPageToFit = YES;
    
    [webViewController.view addSubview: uiWebView];
    [self.navigationController pushViewController:webViewController animated:YES];
    
}

#pragma mark -

@end
