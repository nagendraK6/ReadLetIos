//
//  APPViewController.m
//  ReadLet
//
//  Created by Nagendra on 5/21/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "APPViewController.h"
#import "APPChildViewController.h"
#import "SubscribeNewsletterViewController.h"
#import "NameAddRegistrationViewController.h"
#import "LoggingHelper.h"

@interface APPViewController () 

{
    UILabel *_start_reading;
    UILabel *tc_line_1;
    UILabel *tc_line_2;
    UILabel *tc_line_3;

}
@end

@implementation APPViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _start_reading = [[UILabel alloc] init];
        _start_reading.backgroundColor = [UIColor colorWithRed:70.0f/255.0f green:165.0f/255.0f blue:28.0f/255.0 alpha:1.0f];
        
        
        
        _start_reading.text = @"Start Reading";
        _start_reading.textAlignment = NSTextAlignmentCenter;
        _start_reading.textColor = [UIColor whiteColor];
        [_start_reading setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:24]];
        

        
        _start_reading.layer.borderWidth = 1.0;
        _start_reading.layer.cornerRadius = 7;
        _start_reading.layer.borderColor = [UIColor whiteColor].CGColor;
        _start_reading.layer.masksToBounds = true;
        
        _start_reading.userInteractionEnabled = YES;
        [self setupviews];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    //    [[self.pageController view] setFrame:[[self view] bounds]];
    self.pageController.view.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), self.view.frame.size.height - 200);
    
    APPChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    _start_reading.frame = CGRectMake(self.view.frame.size.width /2 - 150,self.view.frame.size.height - 200 ,300,48);
}

- (APPChildViewController *)viewControllerAtIndex:(NSUInteger)index
{
    APPChildViewController *childViewController = [[APPChildViewController alloc] init];
    childViewController.index = index;
    
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(APPChildViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(APPChildViewController *)viewController index];
    
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (void) viewWillLayoutSubviews {
    [LoggingHelper reportLogsDataToAnalytics:FIRST_SCREEN_VISIBLE];
    tc_line_1.frame = CGRectMake(0 ,self.view.frame.size.height  - 140 ,self.view.frame.size.width,10);
    tc_line_2.frame = CGRectMake(0 ,self.view.frame.size.height -125 ,self.view.frame.size.width,10);
    tc_line_3.frame = CGRectMake(0 ,self.view.frame.size.height -110,self.view.frame.size.width,10);
    
    _start_reading.frame = CGRectMake(self.view.frame.size.width /2 - 150,self.view.frame.size.height - 200 ,300,48);
}

- (void) setupviews {

    
    UITapGestureRecognizer *tapGesture = \
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(didTapLabelWithGesture:)];
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
    
    [self.view addSubview:tc_line_1];
    [self.view addSubview:tc_line_2];
    [self.view addSubview:tc_line_3];
    [self.view addSubview:_start_reading];
}

- (void)didTapLabelWithGesture:(UITapGestureRecognizer *)tapGesture {
    [LoggingHelper reportLogsDataToAnalytics:CLICKED_START_READING];
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    SubscribeNewsletterViewController *vc = [[SubscribeNewsletterViewController alloc] initWithoutFetch];
    
    
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navigation animated:YES completion:^{
        NSLog(@"Completed");
    }];
    
    //  [self presentViewController:vc animated:YES completion:nil];
}





- (void)didTapLabelWithGesture_2:(UITapGestureRecognizer *)tapGesture {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.readlet.io/tos"]];
}

- (void)didTapLabelWithGesture_3:(UITapGestureRecognizer *)tapGesture {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.readlet.io/privacy"]];
}

@end
