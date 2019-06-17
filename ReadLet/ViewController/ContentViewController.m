//
//  ContentViewController.m
//  ReadLet
//
//  Created by Nagendra on 5/6/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "ContentViewController.h"
#import "LoggingHelper.h"
#import <WebKit/WebKit.h>

@interface ContentViewController ()
{
    WKWebView *webView;
    UIActivityIndicatorView *_activityIndicator;
    NSString *current_url;
}

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (id) initWithURLString:(NSString *) url_link  title:(NSString *)title {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
        webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
        webView.navigationDelegate = self;
        NSURL *nsurl=[NSURL URLWithString:url_link];
        current_url = url_link;
        NSMutableURLRequest *nsrequest=[NSMutableURLRequest requestWithURL:nsurl];
        [nsrequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
        [webView loadRequest:nsrequest];
        [self.view addSubview:webView];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancelButtonAction:)];
        self.navigationItem.leftBarButtonItem = doneButton;
        
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:(UIBarButtonItemStyleDone) target:self action:@selector(shareButtonAction:)];
        self.navigationItem.rightBarButtonItem = shareButton;

        
        [LoggingHelper reportLogsDataToAnalytics:RENDER_WEBVIEW];
        self.title = title;
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
        [self.view addSubview:_activityIndicator];
        [_activityIndicator startAnimating];
    }
    return self;
}

- (void) cancelButtonAction:(id)sender {
    if ([webView canGoBack]) {
        [LoggingHelper reportLogsDataToAnalytics:BACK_WEBVIEW];
        [webView goBack];
    } else {
        [LoggingHelper reportLogsDataToAnalytics:CLOSE_WEBVIEW];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) shareButtonAction:(id)sender {
    [LoggingHelper reportLogsDataToAnalytics:CLICKED_SHARE];

    NSString* title = @"Shared via Readlet - The newsletter app";
    NSString* link = webView.URL.absoluteString;
    NSArray* dataToShare = @[title, link];
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                      applicationActivities:nil];
    
    
    // This is key for iOS 8+
    activityViewController.popoverPresentationController.barButtonItem = sender;
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:^{
                         [LoggingHelper reportLogsDataToAnalytics:SHARING_COMPLETE];
                     }];
}



- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    current_url = url.absoluteString;
    
    //this is a 'new window action' (aka target="_blank") > open this URL externally. If we´re doing nothing here, WKWebView will also just do nothing. Maybe this will change in a later stage of the iOS 8 Beta
    if (!navigationAction.targetFrame) {
        [_activityIndicator startAnimating];
        NSURL *url = navigationAction.request.URL;
        current_url = url.absoluteString;
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:url];
        [webView loadRequest:nsrequest];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"Loading complete of webview");
    [LoggingHelper reportLogsDataToAnalytics:RENDER_WEBVIEW_SUCCESS];
   [_activityIndicator stopAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
