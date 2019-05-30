//
//  OTPVerificationViewController.m
//  ReadLet
//
//  Created by Nagendra on 5/16/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "OTPVerificationViewController.h"
#import "NameAddRegistrationViewController.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "PhoneNoAskViewController.h"
#import "LoggingHelper.h"

#define kRefreshTimeInSeconds 1
@interface OTPVerificationViewController ()

@end

@implementation OTPVerificationViewController
{
    UILabel *_otp_description;
    UITextField *_otp_1;
    UITextField *_otp_2;
    UITextField *_otp_3;
    UITextField *_otp_4;
    UIActivityIndicatorView *_activityIndicator;
    UILabel *_otp_in_progress;
    int countdown;
    UILabel *next_button;
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [LoggingHelper reportLogsDataToAnalytics:SCREEN_OTP_ADD_VISIBLE];
    self.view.backgroundColor =  [UIColor whiteColor];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _otp_description = [[UILabel alloc] init];
        _otp_description.text = @"Enter the 4 digits OTP";
        _otp_description.textAlignment = NSTextAlignmentCenter;
        _otp_description.font = [UIFont systemFontOfSize:20];
        
        _otp_in_progress = [[UILabel alloc] init];
        _otp_in_progress.text = @"OTP Vertification in progres ...";
        _otp_in_progress.textAlignment = NSTextAlignmentCenter;
        [_otp_in_progress setHidden:YES];
        
        [self.view addSubview:_otp_description];
        [self.view addSubview:_otp_in_progress];
        
        
        _otp_1 = [[UITextField alloc] init];
        _otp_2 = [[UITextField alloc] init];
        _otp_3 = [[UITextField alloc] init];
        _otp_4 = [[UITextField alloc] init];
        
        _otp_1.textAlignment = NSTextAlignmentCenter;
        _otp_1.secureTextEntry = YES;
        _otp_1.keyboardType = UIKeyboardTypeNumberPad;
        
        _otp_2.textAlignment = NSTextAlignmentCenter;
        _otp_2.secureTextEntry = YES;
        _otp_2.keyboardType = UIKeyboardTypeNumberPad;
        
        
        
        _otp_3.textAlignment = NSTextAlignmentCenter;
        _otp_3.secureTextEntry = YES;
        _otp_3.keyboardType = UIKeyboardTypeNumberPad;
        
        
        _otp_4.textAlignment = NSTextAlignmentCenter;
        _otp_4.secureTextEntry = YES;
        _otp_4.keyboardType = UIKeyboardTypeNumberPad;
        
        _otp_1.delegate = self;
        [_otp_1 addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
        
        _otp_2.delegate = self;
        [_otp_2 addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
        
        _otp_3.delegate = self;
        [_otp_3 addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
        
        _otp_4.delegate = self;
        [_otp_4 addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
        
        
        [self.view addSubview:_otp_1];
        [self.view addSubview:_otp_2];
        [self.view addSubview:_otp_3];
        [self.view addSubview:_otp_4];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.width/2)];
        [self.view addSubview:_activityIndicator];
        
        
        next_button = [[UILabel alloc] init];
        next_button.text = @"Resend OTP";
        next_button.textAlignment = NSTextAlignmentCenter;
        next_button.textColor = [UIColor whiteColor];
        
        next_button.layer.borderWidth = 1.0;
        next_button.layer.cornerRadius = 5;
        next_button.layer.masksToBounds = true;
        next_button.userInteractionEnabled = NO;
        next_button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        next_button.backgroundColor = [UIColor lightGrayColor];
        
        
        UITapGestureRecognizer *tapGesture = \
        [[UITapGestureRecognizer alloc]
         initWithTarget:self action:@selector(didTapLabelWithGesture:)];
        [next_button addGestureRecognizer:tapGesture];
        
        [self.view addSubview:next_button];        
    }
    
    [self startANewTimer];
    
    
    return self;
}

-(void)handleTimer: (id) sender
{
    //Update Values in Label here
    countdown++;
    int time_r = 30 -countdown;
    [next_button setText:[NSString stringWithFormat:@"Resend OTP in %d secs", time_r]];
    if (countdown >= 30) {
        [next_button setText:@"Resend OTP"];
        next_button.userInteractionEnabled = YES;
        next_button.layer.borderColor = [UIColor colorWithRed:0.00 green:0.55 blue:1.00 alpha:1.0].CGColor;
        next_button.backgroundColor = [UIColor colorWithRed:0.00 green:0.55 blue:1.00 alpha:1.0];
        
        [self stopTimer];
    }
}

-(void)stopTimer
{
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void) viewWillLayoutSubviews {
    _otp_description.frame = CGRectMake(self.view.frame.size.width /2 - 100, self.view.frame.size.height /2 - 150, 200, 30);
    _otp_in_progress.frame = CGRectMake(self.view.frame.size.width /2 - 125, self.view.frame.size.height /2 - 150,250, 30);
    
    _otp_1.frame = CGRectMake(self.view.frame.size.width /2 - 80, self.view.frame.size.height /2 - 50,30, 30);
    _otp_2.frame = CGRectMake(self.view.frame.size.width /2 - 35, self.view.frame.size.height /2 - 50,30, 30);
    _otp_3.frame = CGRectMake(self.view.frame.size.width /2 + 5, self.view.frame.size.height /2 - 50,30, 30);
    _otp_4.frame = CGRectMake(self.view.frame.size.width /2 + 55, self.view.frame.size.height /2 - 50,30, 30);
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, _otp_1.frame.size.height - borderWidth, _otp_1.frame.size.width, _otp_1.frame.size.height);
    border.borderWidth = borderWidth;
    [_otp_1.layer addSublayer:border];
    _otp_1.layer.masksToBounds = YES;
    
    CALayer *border2 = [CALayer layer];
    CGFloat borderWidth2 = 2;
    border2.borderColor = [UIColor darkGrayColor].CGColor;
    border2.frame = CGRectMake(0, _otp_2.frame.size.height - borderWidth2, _otp_2.frame.size.width, _otp_2.frame.size.height);
    border2.borderWidth = borderWidth2;
    [_otp_2.layer addSublayer:border2];
    _otp_2.layer.masksToBounds = YES;
    
    
    
    CALayer *border3 = [CALayer layer];
    CGFloat borderWidth3 = 2;
    border3.borderColor = [UIColor darkGrayColor].CGColor;
    border3.frame = CGRectMake(0, _otp_3.frame.size.height - borderWidth3, _otp_3.frame.size.width, _otp_3.frame.size.height);
    border3.borderWidth = borderWidth3;
    [_otp_3.layer addSublayer:border3];
    _otp_3.layer.masksToBounds = YES;
    
    CALayer *border4 = [CALayer layer];
    CGFloat borderWidth4 = 2;
    border4.borderColor = [UIColor darkGrayColor].CGColor;
    border4.frame = CGRectMake(0, _otp_4.frame.size.height - borderWidth4, _otp_4.frame.size.width, _otp_4.frame.size.height);
    border4.borderWidth = borderWidth4;
    [_otp_4.layer addSublayer:border4];
    _otp_4.layer.masksToBounds = YES;
    
    next_button.frame = CGRectMake(self.view.frame.size.width /2 - 100, self.view.frame.size.height /2 + 25, 200, 50);
}

- (void)textFieldDidChange:(UITextField *)textField {
    [LoggingHelper reportLogsDataToAnalytics:TYPING_OTP];
    
    if (textField == _otp_1) {
        [_otp_2 becomeFirstResponder];
    }
    
    if (textField == _otp_2) {
        [_otp_3 becomeFirstResponder];
    }
    
    if (textField == _otp_3) {
        [_otp_4 becomeFirstResponder];
    }
    
    if (textField == _otp_4) {
        // verify all otp.
        [textField resignFirstResponder];
        [_activityIndicator startAnimating];
        [_otp_description setHidden:YES];
        [_otp_in_progress setHidden:NO];
        NSString *otp_value =  [NSString stringWithFormat:@"%@%@%@%@", _otp_1.text, _otp_2.text, _otp_3.text, _otp_4.text];
        
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        NSDictionary *user_info = [data objectForKey:@"user_info"];
        
        if (user_info != nil) {
            // read the token
            NSLog(@"Sending for verification");
            NSString *user_token = [user_info objectForKey:@"user_token"];
            if (user_token != nil) {
                [self verifyOTPNetwork:otp_value user_token:user_token];
            }
        } else {
            NSLog(@"Load the phone registration view");
        }
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [_otp_1 becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 1;
    
}

- (void) showDialog {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"OTP incorrect"
                                                                   message:@"You have entered wrong OTP information. Try again."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) verifyOTPNetwork:(NSString *)otp_string_2 user_token:(NSString *)token {
    
    NSString *address =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"registration/verifyotp"];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:address]];
    NSString *userUpdate =[NSString stringWithFormat:@"otp=%@", otp_string_2];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:[NSString stringWithFormat:@"Token %@", token] forHTTPHeaderField:@"Authorization"];
    
    // client.addHeader("Authorization", "Bearer " + user.AccessToken);
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [LoggingHelper reportLogsDataToAnalytics:OTP_SEND_SERVER_SUCCESS];
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
            
            NSLog(@"The response is - %@",responseDictionary);
            NSString *error_message = [responseDictionary objectForKey:@"error_message"];
            if([error_message  isEqual: @"SUCCESS"]) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *user_info = [defaults objectForKey:@"user_info"];
                NSMutableDictionary *updated_object = [[NSMutableDictionary alloc] initWithDictionary:user_info];
                NSString *new_token = [responseDictionary objectForKey:@"user_token"];
                [updated_object setObject:new_token forKey:@"user_token"];
                [updated_object setObject:[NSNumber numberWithBool:YES] forKey:@"is_otp_verified"];
                NSString *first_name = [responseDictionary objectForKey:@"first_name"];
                NSString *last_name = [responseDictionary objectForKey:@"last_name"];

                NSLog(@"OTP Verified ok");
                BOOL skip_reg = NO;
                if (first_name != nil) {
                    [updated_object setObject:first_name forKey:@"first_name"];
                    [updated_object setObject:last_name forKey:@"last_name"];
                    skip_reg = YES;
                } else {
                    skip_reg = NO;
                }
                
                [defaults setObject:updated_object forKey:@"user_info"];
                
                // store the user token and ither information in user_info
                dispatch_async(dispatch_get_main_queue(), ^{
                    CATransition *transition = [[CATransition alloc] init];
                    transition.duration = 1.0;
                    transition.type = kCATransitionPush;
                    transition.subtype = kCATransitionFromRight;
                    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                    [self.view.window.layer addAnimation:transition forKey:kCATransition];
                    [self->_otp_in_progress setHidden:YES];
                    [self->_activityIndicator stopAnimating];
                    if (skip_reg == YES) {
                        
                        
                        
                        CATransition *transition = [[CATransition alloc] init];
                        transition.duration = 0.5;
                        transition.type = kCATransitionPush;
                        transition.subtype = kCATransitionFromRight;
                        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                        [self.view.window.layer addAnimation:transition forKey:kCATransition];
                        NameAddRegistrationViewController *vc = [[NameAddRegistrationViewController alloc] init];
                        UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
                        [self presentViewController:navigation animated:YES completion:^{
                            NSLog(@"Completed");
                        }];
                        
                        
                    } else {
                        CATransition *transition = [[CATransition alloc] init];
                        transition.duration = 0.5;
                        transition.type = kCATransitionPush;
                        transition.subtype = kCATransitionFromRight;
                        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                        [self.view.window.layer addAnimation:transition forKey:kCATransition];
                        NameAddRegistrationViewController *vc = [[NameAddRegistrationViewController alloc] init];
                        UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
                        [self presentViewController:navigation animated:YES completion:^{
                            NSLog(@"Completed");
                        }];
                    }
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_otp_description setHidden:NO];
                    [self->_otp_1 becomeFirstResponder];
                    self->_otp_description.text = @"Enter the 4 digits OTP";
                    [self->_otp_in_progress setHidden:YES];
                    [self->_activityIndicator stopAnimating];
                    [self->_otp_1 setText:@""];
                    [self->_otp_2 setText:@""];
                    [self->_otp_3 setText:@""];
                    [self->_otp_4 setText:@""];
                    [self showDialog];
                });
                NSLog(@"Login FAILURE");
            }
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    [dataTask resume];
}

- (void) startANewTimer {
    countdown = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval: kRefreshTimeInSeconds
                                              target:self
                                            selector:@selector(handleTimer:)
                                            userInfo:nil
                                             repeats:YES];
    next_button.userInteractionEnabled = NO;
    next_button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    next_button.backgroundColor = [UIColor lightGrayColor];
}

- (void)didTapLabelWithGesture:(UITapGestureRecognizer *)tapGesture {
    [next_button setUserInteractionEnabled:NO];
    [LoggingHelper reportLogsDataToAnalytics:CLICKED_RESEND_OTP];
    [self showResendText];
    [self startANewTimer];
    [self resetOTP];
    [self resendRequest];
}

- (void) resendRequest {
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_info = [data objectForKey:@"user_info"];
    NSString *user_token = [user_info objectForKey:@"user_token"];
    
    NSString *urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"registration/resendOTP"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", user_token] forHTTPHeaderField:@"Authorization"];
    
    
    [manager POST:urlstring parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)responseObject;
        [LoggingHelper reportLogsDataToAnalytics:CLICKED_RESEND_OTP_SERVER_SUCCESS];
        if(httpResponse.statusCode == 401) {
            // unauthorized token...redirect to phone no ask view controller
            PhoneNoAskViewController *vc = [[PhoneNoAskViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [LoggingHelper reportLogsDataToAnalytics:CLICKED_RESEND_OTP_SERVER_FAILED];
    }];
}

- (void) resetOTP {
    [self->_otp_description setHidden:NO];
    [self->_otp_1 becomeFirstResponder];
    self->_otp_description.text = @"Enter the 4 digits OTP";
    [self->_otp_in_progress setHidden:YES];
    [self->_activityIndicator stopAnimating];
    [self->_otp_1 setText:@""];
    [self->_otp_2 setText:@""];
    [self->_otp_3 setText:@""];
    [self->_otp_4 setText:@""];
}

- (void) showResendText {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"You will receive new OTP."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    int duration = 1; // in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
