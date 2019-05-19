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


@interface NameAddRegistrationViewController ()

@end

@implementation NameAddRegistrationViewController
{
    UILabel *name_description;
    UILabel *first_name_description;
    UILabel *last_name_description;
    UILabel *next_button;
    UITextField *first_name;
    UITextField *last_name;
    UIActivityIndicatorView *_activityIndicator;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
        
        next_button = [[UILabel alloc] init];
        next_button.text = @"Next";
        next_button.textAlignment = NSTextAlignmentCenter;
        next_button.textColor = [UIColor whiteColor];
        
        next_button.layer.borderWidth = 1.0;
        next_button.layer.cornerRadius = 20;
        next_button.layer.masksToBounds = true;
        next_button.userInteractionEnabled = NO;
        next_button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        next_button.backgroundColor = [UIColor lightGrayColor];
        
        
        UITapGestureRecognizer *tapGesture = \
        [[UITapGestureRecognizer alloc]
         initWithTarget:self action:@selector(didTapLabelWithGesture:)];
        [next_button addGestureRecognizer:tapGesture];
        
        first_name.delegate = self;
        last_name.delegate = self;
        
        [self.view addSubview:name_description];
        [self.view addSubview:first_name_description];
        [self.view addSubview:last_name_description];
        [self.view addSubview:first_name];
        [self.view addSubview:last_name];
        [self.view addSubview:next_button];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.width/2)];
        [self.view addSubview:_activityIndicator];
        
    }
    return self;
}

- (void)didTapLabelWithGesture:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"Next clicked");
   // [LoggingHelper reportLogsDataToAnalytics:CLICKED_NAME_SEND];
    [last_name resignFirstResponder];
    [first_name resignFirstResponder];
    [_activityIndicator startAnimating];
    [next_button setUserInteractionEnabled:NO];
    [next_button setHidden:YES];
    
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
    name_description.frame = CGRectMake(self.view.frame.size.width /2 - 150, 50,300, 30);
    first_name_description.frame = CGRectMake(30, 100,100, 30);
    first_name.frame = CGRectMake(30, 130,200, 30);
    last_name_description.frame = CGRectMake(30, 170,100, 30);
    last_name.frame = CGRectMake(30, 200,200, 30);
    
    next_button.frame = CGRectMake(self.view.frame.size.width /2 - 75, 250,150, 40);
    
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
  //  [LoggingHelper reportLogsDataToAnalytics:SCREEN_NAME_ASK_VISIBLE];
    [first_name becomeFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField {
  //  [LoggingHelper reportLogsDataToAnalytics:TYPING_NAME];
    if (textField == first_name) {
        if (![first_name.text  isEqual: @""]) {
            next_button.userInteractionEnabled = YES;
            next_button.layer.borderColor = [UIColor colorWithRed:0.00 green:0.55 blue:1.00 alpha:1.0].CGColor;
            next_button.backgroundColor = [UIColor colorWithRed:0.00 green:0.55 blue:1.00 alpha:1.0];
        } else {
        //    [LoggingHelper reportLogsDataToAnalytics:NAME_SEND_BUTTON_ENABLED];
            next_button.userInteractionEnabled = NO;
            next_button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            next_button.backgroundColor = [UIColor lightGrayColor];
        }
    }
}

- (void) sendNameToServer:(NSString *)first_name last_name:(NSString *)last_name user_token:(NSString *)token {
    
    NSString *address =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"registration/user_name_send"];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:address]];
    NSString *userUpdate =[NSString stringWithFormat:@"first_name=%@&last_name=%@", first_name, last_name];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:[NSString stringWithFormat:@"Token %@", token] forHTTPHeaderField:@"Authorization"];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       // [LoggingHelper reportLogsDataToAnalytics:NAME_SEND_SERVER_SUCCESS];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 401) {
            // unauthorized token...redirect to phone no ask view controller
            PhoneNoAskViewController *vc = [[PhoneNoAskViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
        
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSString *error_message = [responseDictionary objectForKey:@"error_message"];
            if([error_message  isEqual: @"SUCCESS"]) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *user_info = [defaults objectForKey:@"user_info"];
                NSMutableDictionary *updated_object = [[NSMutableDictionary alloc] initWithDictionary:user_info];
                
                [updated_object setObject:first_name forKey:@"first_name"];
                [updated_object setObject:last_name forKey:@"last_name"];
                
                [defaults setObject:updated_object forKey:@"user_info"];
                NSLog(@"Name added successfully");
                
                // store the user token and ither information in user_info
                dispatch_async(dispatch_get_main_queue(), ^{
                    CATransition *transition = [[CATransition alloc] init];
                    transition.duration = 1.0;
                    transition.type = kCATransitionPush;
                    transition.subtype = kCATransitionFromRight;
                    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                    [self.view.window.layer addAnimation:transition forKey:kCATransition];
                    
                    SubscribeNewsletterViewController *vc = [[SubscribeNewsletterViewController alloc] init];
                    
                    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
                    [self presentViewController:navigation animated:YES completion:^{
                        NSLog(@"Completed");
                    }];
                });
            }
            else
            {
                NSLog(@"Name add failed");
            }
        }
        else
        {
            //[LoggingHelper reportLogsDataToAnalytics:NAME_SEND_SERVER_FAILED];
            NSLog(@"http response is not 200");
        }
    }];
    [dataTask resume];
}



@end

