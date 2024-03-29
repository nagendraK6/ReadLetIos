//
//  RequestForNotificationViewController.m
//  ReadLet
//
//  Created by Nagendra on 5/28/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "RequestForNotificationViewController.h"
#import "MainScreenViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "LoggingHelper.h"
@interface RequestForNotificationViewController ()

@end

@implementation RequestForNotificationViewController
{
    UILabel *title;
    UILabel *description;
    UIImageView *skip;
    UIImageView *allow;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (instancetype)init
{
    self = [super init];
    if (self) {
        title = [[UILabel alloc] init];
        description = [[UILabel alloc] init];
        skip = [[UIImageView alloc] init];
        allow = [[UIImageView alloc] init];

        skip.image = [UIImage imageNamed:@"skip"];
        allow.image = [UIImage imageNamed:@"allow"];
        allow.contentMode = UIViewContentModeScaleAspectFill;

        title.text = @"Allow us to notify you";
        description.text = @"Would you like us to send you notifications when your newsletters arrive?";
        
        
        title.font = [UIFont systemFontOfSize:18];
        title.textColor = [UIColor colorWithRed:74.0f/255.0f
                                          green:74.0f/255.0f
                                           blue:74.0f/255.0f
                                          alpha:1.0f];
        
        description.font = [UIFont systemFontOfSize:24];
        description.textColor = [UIColor colorWithRed:74.0f/255.0f
                                          green:74.0f/255.0f
                                           blue:74.0f/255.0f
                                          alpha:1.0f];
        
        description.lineBreakMode = NSLineBreakByWordWrapping;
        description.numberOfLines = 0;
        
        //[self.view addSubview:title];
        [self.view addSubview:description];
        [self.view addSubview:skip];
        [self.view addSubview:allow];
        self.navigationItem.title = @"Allow us to notify you";
        
        
        allow.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = \
        [[UITapGestureRecognizer alloc]
         initWithTarget:self action:@selector(allowClicked:)];
        [allow addGestureRecognizer:tapGesture];

        skip.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureSkip = \
        [[UITapGestureRecognizer alloc]
         initWithTarget:self action:@selector(skipClicked:)];
        [skip addGestureRecognizer:tapGestureSkip];
        [LoggingHelper reportLogsDataToAnalytics:REQUEST_FOR_NOTIFICATION_VISIBLE];
    }
    return self;
}

- (void) allowClicked:(UITapGestureRecognizer *)tapGesture {
    // popup
#if TARGET_IPHONE_SIMULATOR
    MainScreenViewController *vc = [[MainScreenViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
#elif TARGET_OS_IPHONE
    [self registerForRemoteNotifications];
#endif
}

- (void) skipClicked:(UITapGestureRecognizer *)tapGesture {
    [LoggingHelper reportLogsDataToAnalytics:SKIPPED_NOTIFICATION];
    MainScreenViewController *vc = [[MainScreenViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    title.frame = CGRectMake(16, 100, self.view.frame.size.width - 42, 60);
    description.frame = CGRectMake(16, 264, self.view.frame.size.width - 42, 200);
    skip.frame = CGRectMake(self.view.frame.size.width /2 - 160, 450, 150, 48);
    allow.frame = CGRectMake(self.view.frame.size.width /2 + 10 , 450, 150, 48);
}

- (void)registerForRemoteNotifications {
    [LoggingHelper reportLogsDataToAnalytics:REGISTERED_FOR_NOTIFICATION];
    if(@available(iOS 10.0, *)){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if(!error){
                     [[UIApplication sharedApplication] registerForRemoteNotifications];
                }
                
                MainScreenViewController *vc = [[MainScreenViewController alloc] init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }];
    }
    else {
        // Code for old versions
    }
}


@end
