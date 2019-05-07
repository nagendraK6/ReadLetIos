//
//  ContentViewController.m
//  ReadLet
//
//  Created by Nagendra on 5/6/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "ContentViewController.h"
#import <WebKit/WebKit.h>

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id) initWithURLString:(NSString *) url_link {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
        //webView.navigationDelegate = self;
        NSURL *nsurl=[NSURL URLWithString:url_link];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [webView loadRequest:nsrequest];
        [self.view addSubview:webView];
        
        
    }
    return self;
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
