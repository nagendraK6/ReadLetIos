//
//  GetStartedViewController.m
//  Story
//
//  Created by Nagendra on 11/19/18.
//  Copyright © 2018 Nagendra. All rights reserved.
//

#import "GetStartedViewController.h"
#import "PhoneNoAskViewController.h"
#import "SubscribeNewsletterViewController.h"
@interface GetStartedViewController ()

@end

@implementation GetStartedViewController
{
    UILabel *_getStarted;
    UILabel *tc_line_1;
    UILabel *tc_line_2;
    UILabel *tc_line_3;
    
    UIImageView *_centerLogo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [LoggingHelper reportLogsDataToAnalytics:SCREEN_GET_STARTED_VISIBLE];
}

- (instancetype) init {
    self = [super init];
    if (self) {
        _getStarted = [[UILabel alloc] init];
        _getStarted.text = @"Start Reading";
        _getStarted.textAlignment = NSTextAlignmentCenter;
        _getStarted.backgroundColor = [UIColor colorWithRed:0.00 green:0.55 blue:1.00 alpha:1.0];
        _getStarted.textColor = [UIColor whiteColor];
        
        _getStarted.layer.borderWidth = 2.0;
        _getStarted.layer.cornerRadius = 30;
        _getStarted.layer.masksToBounds = true;
        
        _getStarted.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = \
        [[UITapGestureRecognizer alloc]
         initWithTarget:self action:@selector(didTapLabelWithGesture:)];
        [_getStarted addGestureRecognizer:tapGesture];
        
        
        tc_line_1 = [[UILabel alloc] init];
        tc_line_2 = [[UILabel alloc] init];
        tc_line_3 = [[UILabel alloc] init];
        
        
        tc_line_2.userInteractionEnabled = YES;
        tc_line_3.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture_2 = \
        [[UITapGestureRecognizer alloc]
         initWithTarget:self action:@selector(didTapLabelWithGesture_2:)];
        [tc_line_2 addGestureRecognizer:tapGesture_2];
        
        UITapGestureRecognizer *tapGesture_3 = \
        [[UITapGestureRecognizer alloc]
         initWithTarget:self action:@selector(didTapLabelWithGesture_3:)];
        [tc_line_3 addGestureRecognizer:tapGesture_3];
        
        
        _centerLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"getstarted"]];
        
        
        tc_line_1.text = @"By clicking on Get Started button, you agree";
        
        NSMutableAttributedString *attributedString_1 = [[NSMutableAttributedString alloc] initWithString:@"to the Reel's terms and conditions and" attributes:nil];
        NSRange linkRange_1 = NSMakeRange(14, 20); // for the word "link" in the string above
        
        NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
        [attributedString_1 setAttributes:linkAttributes range:linkRange_1];
        
        // Assign attributedText to UILabel
        NSMutableAttributedString *attributedString_2 = [[NSMutableAttributedString alloc] initWithString:@"Privacy Policy" attributes:nil];
        
        
        NSRange linkRange_2 = NSMakeRange(0, 14); // for the word "link" in the string above
        
        [attributedString_2 setAttributes:linkAttributes range:linkRange_2];
        
        
        tc_line_2.attributedText = attributedString_1;
        tc_line_3.attributedText = attributedString_2;
        
        
        tc_line_1.textAlignment = NSTextAlignmentCenter;
        tc_line_2.textAlignment = NSTextAlignmentCenter;
        tc_line_3.textAlignment = NSTextAlignmentCenter;
        
        tc_line_1.font = [UIFont systemFontOfSize:10];
        tc_line_2.font = [UIFont systemFontOfSize:10];
        tc_line_3.font = [UIFont systemFontOfSize:10];
        
        [self.view addSubview:_centerLogo];
        [self.view addSubview:tc_line_1];
        [self.view addSubview:tc_line_2];
        [self.view addSubview:tc_line_3];
        [self.view addSubview:_getStarted];
    }
    
    return self;
}

- (void)didTapLabelWithGesture:(UITapGestureRecognizer *)tapGesture {
   // [LoggingHelper reportLogsDataToAnalytics:CLICKED_GET_STARTED];
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    PhoneNoAskViewController *vc = [[PhoneNoAskViewController alloc] init];
    
    
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navigation animated:YES completion:^{
        NSLog(@"Completed");
    }];
    
  //  [self presentViewController:vc animated:YES completion:nil];
}





- (void)didTapLabelWithGesture_2:(UITapGestureRecognizer *)tapGesture {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://rely.ai/tc.html"]];
}

- (void)didTapLabelWithGesture_3:(UITapGestureRecognizer *)tapGesture {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://rely.ai/privacy.html"]];
}

- (void) viewWillLayoutSubviews {
    _centerLogo.frame = CGRectMake(self.view.frame.size.width /2 -125, self.view.frame.size.height /2 - 200 ,250,200);
    
    tc_line_1.frame = CGRectMake(0 ,self.view.frame.size.height / 2 + 50 ,self.view.frame.size.width,10);
    tc_line_2.frame = CGRectMake(0 ,self.view.frame.size.height / 2 + 60,self.view.frame.size.width,10);
    tc_line_3.frame = CGRectMake(0 ,self.view.frame.size.height / 2 + 70,self.view.frame.size.width,10);
    
    _getStarted.frame = CGRectMake(self.view.frame.size.width /2 - 100,self.view.frame.size.height / 2 + 100 ,200,60);
}

@end
