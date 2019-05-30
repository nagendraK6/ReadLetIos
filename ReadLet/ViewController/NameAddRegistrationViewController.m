//
//  NameAddRegistrationViewController.m
//  ReadLet
//
//  Created by Nagendra on 5/16/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "NameAddRegistrationViewController.h"
#import "Constants.h"
#import "MainScreenViewController.h"
#import "PhoneNoAskViewController.h"
#import "SubscribeNewsletterViewController.h"
#import "AFNetworking.h"
#import "LoggingHelper.h"
#import "RequestForNotificationViewController.h"

@interface NameAddRegistrationViewController ()

@end

@implementation NameAddRegistrationViewController
{
    UILabel *name_description;
    UILabel *first_name_description;
    UILabel *last_name_description;
    UITextField *first_name;
    UITextField *last_name;
    UIActivityIndicatorView *_activityIndicator;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        name_description = [[UILabel alloc] init];
        name_description.text = @"Tell us your name";
        name_description.textAlignment = NSTextAlignmentCenter;
        
        first_name_description = [[UILabel alloc] init];
        first_name_description.text = @"First Name";
        first_name_description.textColor = [UIColor lightGrayColor];
        
        last_name_description = [[UILabel alloc] init];
        last_name_description.text = @"Last Name";
        last_name_description.textColor = [UIColor lightGrayColor];
        
        first_name = [[UITextField alloc] init];
        last_name = [[UITextField alloc] init];
        
        first_name.delegate = self;
        last_name.delegate = self;
        
        [self.view addSubview:name_description];
        [self.view addSubview:first_name_description];
        [self.view addSubview:last_name_description];
        [self.view addSubview:first_name];
        [self.view addSubview:last_name];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.width/2)];
        [self.view addSubview:_activityIndicator];
        
        self.navigationItem.title = @"Step 3 of 4";
        
        UIBarButtonItem *next_button = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
        next_button.tintColor = [UIColor lightGrayColor];
        self.navigationItem.rightBarButtonItem=next_button;

        
    }
    return self;
}

-(void)rightBtnClick{
    NSLog(@"Next clicked");
    [LoggingHelper reportLogsDataToAnalytics:CLICKED_NAME_SEND];
    [last_name resignFirstResponder];
    [first_name resignFirstResponder];
    [_activityIndicator startAnimating];
    
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_info = [data objectForKey:@"user_info"];
    
    if (user_info != nil) {
        // read the token
        NSLog(@"Sending for verification");
        NSString *user_token = [user_info objectForKey:@"user_token"];
        if (user_token != nil) {
            [self sendNameToServer:first_name.text last_name:last_name.text  user_token:user_token];
        }
    } else {
        NSLog(@"Load the phone registration view");
    }
    
}

- (void) viewWillLayoutSubviews {
    
    name_description.frame = CGRectMake(self.view.frame.size.width /2 - 150, self.view.frame.size.height /2 - 200 ,300, 30);
    first_name_description.frame = CGRectMake(30, self.view.frame.size.height /2 - 150,100, 30);
    first_name.frame = CGRectMake(30, self.view.frame.size.height /2 - 130,200, 30);
    last_name_description.frame = CGRectMake(30, self.view.frame.size.height /2 - 100,100, 30);
    last_name.frame = CGRectMake(30, self.view.frame.size.height /2 - 80 ,200, 30);
    
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    border.frame = CGRectMake(0, first_name.frame.size.height - borderWidth, first_name.frame.size.width, first_name.frame.size.height);
    border.borderWidth = borderWidth;
    [first_name.layer addSublayer:border];
    first_name.layer.masksToBounds = YES;
    
    [first_name addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    
    
    [last_name addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    CALayer *border2 = [CALayer layer];
    CGFloat borderWidth2 = 1;
    border2.borderColor = [UIColor lightGrayColor].CGColor;
    border2.frame = CGRectMake(0, last_name.frame.size.height - borderWidth2, last_name.frame.size.width, last_name.frame.size.height);
    border2.borderWidth = borderWidth2;
    [last_name.layer addSublayer:border2];
    last_name.layer.masksToBounds = YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [LoggingHelper reportLogsDataToAnalytics:SCREEN_NAME_ASK_VISIBLE];
    [first_name becomeFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField {
    [LoggingHelper reportLogsDataToAnalytics:TYPING_NAME];
    if (textField == first_name) {
        if (![first_name.text  isEqual: @""]) {
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.00 green:0.55 blue:1.00 alpha:1.0];
        } else {
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
        }
    }
}

- (void) sendNameToServer:(NSString *)first_name last_name:(NSString *)last_name user_token:(NSString *)token {
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_info = [data objectForKey:@"user_info"];
    NSArray *selected_provider_ids = [user_info objectForKey:@"selected_provider_ids"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token] forHTTPHeaderField:@"Authorization"];
    
    NSString *urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"registration/user_name_send"];
    
    
    NSDictionary *params = @{
                             @"provider_ids": selected_provider_ids,
                             @"first_name" : first_name,
                             @"last_name": last_name
                             };
    
    
    
    [manager POST:urlstring parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *user_info = [defaults objectForKey:@"user_info"];
        NSMutableDictionary *updated_object = [[NSMutableDictionary alloc] initWithDictionary:user_info];
        
        [updated_object setObject:@YES forKey:@"has_subscribed"];
        [defaults setObject:updated_object forKey:@"user_info"];
        
        
        CATransition *transition = [[CATransition alloc] init];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.view.window.layer addAnimation:transition forKey:kCATransition];
        RequestForNotificationViewController *vc = [[RequestForNotificationViewController alloc] init];
        UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navigation animated:YES completion:^{
            NSLog(@"Completed");
        }];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [LoggingHelper reportLogsDataToAnalytics:PHONE_SEND_SERVER_FAILED];
        NSLog(@"Error: %@", error);
    }];
}



@end

