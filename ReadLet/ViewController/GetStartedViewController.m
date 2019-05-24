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
    UILabel *app_name;
    UILabel *title_name;
    UILabel *description;

    UILabel *tc_line_1;
    UILabel *tc_line_2;
    UILabel *tc_line_3;
    
    UIImageView *_centerLogo;
    UIImageView *_start_reading;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [LoggingHelper reportLogsDataToAnalytics:SCREEN_GET_STARTED_VISIBLE];
}

- (instancetype) init {
    self = [super init];
    if (self) {
        app_name = [[UILabel alloc] init];
        app_name.text = @"Readlet";
        app_name.textAlignment = NSTextAlignmentCenter;
        app_name.font = [UIFont boldSystemFontOfSize:36];
        app_name.textColor = [UIColor colorWithRed:74.0f/255.0f
                                          green:74.0f/255.0f
                                           blue:74.0f/255.0f
                                          alpha:1.0f];
        

        title_name = [[UILabel alloc] init];
        title_name.text = @"Your information diet";
        title_name.textAlignment = NSTextAlignmentCenter;
        title_name.font = [UIFont boldSystemFontOfSize:18];
        title_name.textColor = [UIColor colorWithRed:74.0f/255.0f
                                             green:74.0f/255.0f
                                              blue:74.0f/255.0f
                                             alpha:1.0f];

        
        
        description = [[UILabel alloc] init];
        description.text = @"Readlet’s curated newsletters help you make sense of the news  around you";
        description.textAlignment = NSTextAlignmentCenter;
        description.font = [UIFont boldSystemFontOfSize:18];
        description.textColor = [UIColor colorWithRed:79.0f/255.0f
                                               green:111.0f/255.0f
                                                blue:13.0f/255.0f
                                               alpha:1.0f];
        
        description.lineBreakMode = NSLineBreakByWordWrapping;
        description.numberOfLines = 0;

        
        _getStarted = [[UILabel alloc] init];
        _getStarted.text = @"Start Reading";
        _getStarted.textAlignment = NSTextAlignmentCenter;
        _getStarted.backgroundColor = [UIColor colorWithRed:0.00 green:0.55 blue:1.00 alpha:1.0];
        _getStarted.textColor = [UIColor whiteColor];
        
        _getStarted.layer.borderWidth = 2.0;
        _getStarted.layer.cornerRadius = 30;
        _getStarted.layer.masksToBounds = true;
        
        _getStarted.userInteractionEnabled = YES;
        
        
        _start_reading = [[UIImageView alloc] init];
        _start_reading.image = [UIImage imageNamed:@"startreading"];
        _start_reading.userInteractionEnabled = YES;

        UITapGestureRecognizer *tapGesture = \
        [[UITapGestureRecognizer alloc]
         initWithTarget:self action:@selector(didTapLabelWithGesture:)];
        [_getStarted addGestureRecognizer:tapGesture];
        [_start_reading addGestureRecognizer:tapGesture];

        
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
        
        
        tc_line_1.text = @"By clicking on Start Reading button, you agree";
        
        NSMutableAttributedString *attributedString_1 = [[NSMutableAttributedString alloc] initWithString:@"to the Readlet's terms and conditions and" attributes:nil];
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
        [self.view addSubview:_start_reading];
        [self.view addSubview:app_name];
        [self.view addSubview:title_name];
        [self.view addSubview:description];
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
    _centerLogo.frame = CGRectMake(self.view.frame.size.width /2 - 90, 100 ,180,180);
    app_name.frame = CGRectMake(0, 290 ,self.view.frame.size.width  ,50);
    title_name.frame = CGRectMake(0, 330 ,self.view.frame.size.width  ,30);
    description.frame = CGRectMake(self.view.frame.size.width / 2 - 135, 450 ,270  ,100);
    
    
    tc_line_1.frame = CGRectMake(0 ,self.view.frame.size.height  - 140 ,self.view.frame.size.width,10);
    tc_line_2.frame = CGRectMake(0 ,self.view.frame.size.height -125 ,self.view.frame.size.width,10);
    tc_line_3.frame = CGRectMake(0 ,self.view.frame.size.height -110,self.view.frame.size.width,10);
    
    _start_reading.frame = CGRectMake(self.view.frame.size.width /2 - 150,self.view.frame.size.height - 200 ,300,48);
}

@end
