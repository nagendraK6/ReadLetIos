//
//  PhoneNoAskViewController.m
//  ReadLet
//
//  Created by Nagendra on 5/16/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "PhoneNoAskViewController.h"
#import "Constants.h"
#import "OTPVerificationViewController.h"
#import "AFNetworking.h"
#import "Constants.h"


@interface PhoneNoAskViewController ()

@end

@implementation PhoneNoAskViewController
{
    UILabel *_phone_ask_description;
    UILabel *_phone_title_description;
    UITextField *_phone;
    UIActivityIndicatorView *_activityIndicator;
    UILabel *reason_ask;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[LoggingHelper reportLogsDataToAnalytics:SCREEN_PHONE_NO_ASK_VISIBLE];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (instancetype) init {
    self = [super init];
    if (self) {
        _phone = [[UITextField alloc] init];
        _phone.keyboardType = UIKeyboardTypeNumberPad;
        
        _phone.delegate = self;
        [_phone addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.width/2)];
        [self.view addSubview:_activityIndicator];
        [self.view addSubview:_phone];
        
        _phone_ask_description = [[UILabel alloc] init];
        _phone_ask_description.text = @"Tell us your phone no";
        _phone_ask_description.textAlignment = NSTextAlignmentCenter;
        _phone_ask_description.font = [UIFont systemFontOfSize:25];
        
        _phone_title_description = [[UILabel alloc] init];
        _phone_title_description.text = @"Phone No";
        _phone_title_description.textColor = [UIColor grayColor];
        
        reason_ask = [[UILabel alloc] init];
        reason_ask.text = @"We will send an SMS message to verify your phone number. Carrier SMS charge may apply.";
        reason_ask.textColor = [UIColor blackColor];
        reason_ask.textAlignment = NSTextAlignmentCenter;
        reason_ask.font = [UIFont systemFontOfSize:10];
        reason_ask.numberOfLines = 0;
        
        
        [self.view addSubview:_phone_ask_description];
        [self.view addSubview:_phone_title_description];
        [self.view addSubview:reason_ask];
    }
    
    return self;
}

- (void) viewWillLayoutSubviews {
    _phone_ask_description.frame = CGRectMake(self.view.frame.size.width /2 - 150, self.view.frame.size.height /2 - 150,300, 30);
    _phone_title_description.frame = CGRectMake(30, self.view.frame.size.height /2 -80,100, 30);
    _phone.frame = CGRectMake(30, self.view.frame.size.height /2 - 50, self.view.frame.size.width - 100 , 30);
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    border.frame = CGRectMake(0, _phone.frame.size.height - borderWidth, _phone.frame.size.width, _phone.frame.size.height);
    border.borderWidth = borderWidth;
    [_phone.layer addSublayer:border];
    _phone.layer.masksToBounds = YES;
    
    reason_ask.frame = CGRectMake(30, self.view.frame.size.height /2 -25, self.view.frame.size.width - 40 , 100);
}

- (void)textFieldDidChange:(UITextField *)textField {
}

- (void) viewDidAppear:(BOOL)animated {
    [_phone becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    NSString *decimalString = [components componentsJoinedByString:@""];
    
    NSUInteger length = decimalString.length;
    BOOL hasLeadingOne = length > 0 && [decimalString characterAtIndex:0] == '1';
    //[LoggingHelper reportLogsDataToAnalytics:TYPING_PHONE_NO];
    
    if (length == 0 || (length > 10 && !hasLeadingOne) || (length > 11)) {
        textField.text = decimalString;
        return NO;
    }
    
    NSUInteger index = 0;
    NSMutableString *formattedString = [NSMutableString string];
    
    if (hasLeadingOne) {
        [formattedString appendString:@"1 "];
        index += 1;
    }
    
    if (length - index > 3) {
        NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 3)];
        [formattedString appendFormat:@"%@-",areaCode];
        index += 3;
    }
    
    if (length - index > 3) {
        NSString *prefix = [decimalString substringWithRange:NSMakeRange(index, 3)];
        [formattedString appendFormat:@"%@-",prefix];
        index += 3;
    }
    
    NSString *remainder = [decimalString substringFromIndex:index];
    [formattedString appendString:remainder];
    
    textField.text = formattedString;
    
    if (decimalString.length == 10) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Phone no confirmation"
                                     message:[NSString stringWithFormat: @"Please confirm that phone number is %@", textField.text]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        [textField resignFirstResponder];
                                        [self->_activityIndicator startAnimating];
                                        
                                        // show loading indicator and send the user registration call
                                        //    [self startRegistration:decimalString];
                                        [self startRegistrationAtServer:decimalString];
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Change it"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                       //[LoggingHelper reportLogsDataToAnalytics:CHANGED_PHONE_NO];
                                       self->_phone.text = @"";
                                   }];
        
        [noButton setValue:[UIColor grayColor] forKey:@"titleTextColor"];
        [alert addAction:noButton];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    return NO;
}

- (void) startRegistrationAtServer:(NSString *)decimalString {
    NSString *urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"registration/login"];
    NSDictionary *params = @{
                             @"country_code": @"+1",
                             @"phone_no": decimalString
                             };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlstring parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        //[LoggingHelper reportLogsDataToAnalytics:PHONE_SEND_SERVER_SUCCESS];
        NSLog(@"The response is - %@",responseDictionary);
        NSString *error_message = [responseDictionary objectForKey:@"error_message"];
        if([error_message  isEqual: @"SUCCESS"]) {
            NSMutableDictionary *user_info = [[NSMutableDictionary alloc] init];
            
            [user_info setObject:[NSNumber numberWithBool:NO] forKey:@"is_otp_verified"];
            [user_info setObject:[responseDictionary objectForKey:@"user_id"] forKey:@"user_id"];
            [user_info setObject:decimalString forKey:@"phone_no"];
            [user_info setObject:@"+1" forKey:@"country_code"];
            [user_info setObject:[responseDictionary objectForKey:@"user_token"] forKey:@"user_token"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:user_info forKey:@"user_info"];
            
            NSLog(@"Login SUCCESS");
            
            // store the user token and ither information in user_info
            dispatch_async(dispatch_get_main_queue(), ^{
                CATransition *transition = [[CATransition alloc] init];
                transition.duration = 0.5;
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [self.view.window.layer addAnimation:transition forKey:kCATransition];
                OTPVerificationViewController *vc = [[OTPVerificationViewController alloc] init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
        else
        {
            NSLog(@"Login FAILURE");
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        //[LoggingHelper reportLogsDataToAnalytics:PHONE_SEND_SERVER_FAILED];
        NSLog(@"Error: %@", error);
    }];
}

@end

