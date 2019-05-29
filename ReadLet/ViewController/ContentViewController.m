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
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [webView loadRequest:nsrequest];
        [self.view addSubview:webView];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancelButtonAction:)];
        self.navigationItem.leftBarButtonItem = doneButton;
        [LoggingHelper reportLogsDataToAnalytics:RENDER_WEBVIEW];
        self.title = title;
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



- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //this is a 'new window action' (aka target="_blank") > open this URL externally. If we´re doing nothing here, WKWebView will also just do nothing. Maybe this will change in a later stage of the iOS 8 Beta
    if (!navigationAction.targetFrame) {
        NSURL *url = navigationAction.request.URL;
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:url];
        [webView loadRequest:nsrequest];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
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
