//
//  SignupWithEmailViewController.m
//  ReadLet
//
//  Created by Nagendra on 6/11/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "SigninWithEmailViewController.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "RequestForNotificationViewController.h"
#import "RequestForNewPasswordViewController.h"
#import "LoggingHelper.h"
#import "Helper.h"

@interface SigninWithEmailViewController ()

@end

@implementation SigninWithEmailViewController
{
    UILabel *title;
    UITextField *email;
    UITextField *password;
    UIImageView *next;
    UILabel *forgot_password;
    UIActivityIndicatorView *_activityIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    email.frame = CGRectMake(48, 150, self.view.frame.size.width - 96, 52);
    password.frame = CGRectMake(48, 225, self.view.frame.size.width - 96, 52);
    
    next.frame = CGRectMake(self.view.frame.size.width /2 - 75, 300, 151, 48);
    forgot_password.frame = CGRectMake(self.view.frame.size.width /2 - 100, 370, 200, 48);
    
    title.frame = CGRectMake(16, 100, self.view.frame.size.width - 96, 61);
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12.5, 20)];
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12.5, 20)];
    
    
    
    
    email.layer.cornerRadius = 8.0f;
    email.layer.borderWidth = 1.0f;
    email.layer.borderColor = [UIColor lightGrayColor].CGColor;
    email.layer.masksToBounds = YES;
    
    email.leftView = paddingView;
    email.leftViewMode = UITextFieldViewModeAlways;
    [next setUserInteractionEnabled:YES];
    [forgot_password setUserInteractionEnabled:YES];
    
    password.layer.cornerRadius = 8.0f;
    password.layer.borderWidth = 1.0f;
    password.layer.borderColor = [UIColor lightGrayColor].CGColor;
    password.layer.masksToBounds = YES;
    
    password.leftView = paddingView1;
    password.leftViewMode = UITextFieldViewModeAlways;
    
    [email addTarget:self
              action:@selector(textFieldDidChange:)
    forControlEvents:UIControlEventEditingChanged];
    
    [password addTarget:self
                 action:@selector(textFieldDidChange:)
       forControlEvents:UIControlEventEditingChanged];
    
    
    [email becomeFirstResponder];
    
    UITapGestureRecognizer *tapGesture = \
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(signupEmail:)];
    [next addGestureRecognizer:tapGesture];

    
    UITapGestureRecognizer *tapForgotPasswordGesture = \
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(resetPasswordSend:)];
    [forgot_password addGestureRecognizer:tapForgotPasswordGesture];
    [LoggingHelper reportLogsDataToAnalytics:SIGNIN_WITH_EMAIL_VISIBLE];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if([self shouldEnable] == YES) {
        next.image = [UIImage imageNamed:@"nextdark"];
        [next setUserInteractionEnabled:YES];
        
    } else {
        next.image = [UIImage imageNamed:@"nextgray"];
        [next setUserInteractionEnabled:NO];
        
    }
}

- (void) signupEmail:(UITapGestureRecognizer *)tapGesture {
    if ([Helper validateEmailWithString:email.text] == NO) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Email incorrect"
                                     message:@"Email has invalid characters"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self sendSignInWithEmail];
}


- (void) resetPasswordSend:(UITapGestureRecognizer *)tapGesture {
    if ([Helper validateEmailWithString:email.text] == NO) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Email incorrect"
                                     message:@"Email has invalid characters"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self showForgotPasswordPopup];
}

- (BOOL) shouldEnable {
    if ([email.text  isEqual: @""]) {
        return NO;
    }
    
    if ([password.text  isEqual: @""]) {
        return NO;
    }
    
    return YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultFieldsContent];
    }
    return self;
}


- (void) defaultFieldsContent {
    title = [[UILabel alloc] init];
    title.text = @"Sign in with email";
    [title setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:18]];
    title.textColor = [UIColor colorWithRed:74.0f/255.0f
                                      green:74.0f/255.0f
                                       blue:74.0f/255.0f
                                      alpha:1.0f];
    
    
    next = [[UIImageView alloc] init];
    next.image = [UIImage imageNamed:@"nextgray"];
    
    
    
    
    
    email = [[UITextField alloc] init];
    email.placeholder = @"Email";
    
    password = [[UITextField alloc] init];
    password.placeholder = @"Password (must be 8 characters)";
    password.secureTextEntry = YES;
    
    
    forgot_password = [[UILabel alloc] init];
    forgot_password.text = @"Forgot password?";
    forgot_password.textColor  = [UIColor colorWithRed:0.00f/255.0f
                                                            green:118.00f/255.0f
                                                             blue:255.0f/255.0f
                                                            alpha:1.0f];
    forgot_password.textAlignment = NSTextAlignmentCenter;
    forgot_password.textAlignment = NSTextAlignmentCenter;
    [forgot_password setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    
    
    [self.view addSubview:email];
    [self.view addSubview:password];
    [self.view addSubview:forgot_password];
    
   // [self.view addSubview:title];
    [self.view addSubview:next];
    self.navigationItem.title = @"Sign in";

    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.width/2)];
    [self.view addSubview:_activityIndicator];
    
    
    UIBarButtonItem *left_btn = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    left_btn.tintColor = [UIColor colorWithRed:0.0f/255.0f green:118.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    [left_btn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName,
                                        
                                        nil]
                              forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem=left_btn;
    
}


- (void) leftBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (instancetype)initWithEmail:(NSString *)email_to_show
{
    self = [super init];
    if (self) {
        [self defaultFieldsContent];
        email.text = email_to_show;
    }
    return self;
}


- (void) sendSignInWithEmail {
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_info = [data objectForKey:@"user_info"];
    NSArray *selected_provider_ids = [user_info objectForKey:@"selected_provider_ids"];
    
    NSString *urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"registration/login_with_email"];
    NSURL *URL = [NSURL URLWithString:urlstring];
    
    [_activityIndicator startAnimating];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"provider_ids": selected_provider_ids,
                                 @"email" : email.text,
                                 @"password": password.text
                                 };
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"send device token JSON: %@", responseObject);
        // save the user token from the server
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSString *error_message = [responseDictionary objectForKey:@"error_message"];
        if ([error_message isEqualToString:@"SUCCESS"]) {
            [LoggingHelper reportLogsDataToAnalytics:SIGNIN_WITH_EMAIL_SUCCESS];

            
            NSDictionary *old_info = [data objectForKey:@"user_info"];
            NSMutableDictionary *user_info = [[NSMutableDictionary alloc] initWithDictionary:old_info];
            
            [user_info setObject:@YES forKey:@"has_subscribed"];
            [user_info setObject:[NSNumber numberWithBool:NO] forKey:@"is_otp_verified"];
            [user_info setObject:[responseDictionary objectForKey:@"user_id"] forKey:@"user_id"];
            [user_info setObject:[responseDictionary objectForKey:@"user_token"] forKey:@"user_token"];
            [user_info setObject:@YES forKey:@"has_subscribed"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:user_info forKey:@"user_info"];
            
            RequestForNotificationViewController *vc = [[RequestForNotificationViewController alloc] init];
            UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:navigation animated:YES completion:^{
                NSLog(@"Completed");
            }];
        } else {
            // existing user case
            [LoggingHelper reportLogsDataToAnalytics:SIGNIN_WITH_EMAIL_PASSWORD_INCORRECT];

            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Password incorrect"
                                         message:@"Your password is incorrect. Try again. You can reset your password by clickng the forgot password link below"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        [self->_activityIndicator stopAnimating];

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



- (void) sendPasswordResetKey {
    NSString *urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"registration/send_reset_password_key"];
    NSURL *URL = [NSURL URLWithString:urlstring];
    
    [_activityIndicator startAnimating];
    [LoggingHelper reportLogsDataToAnalytics:SIGNIN_WITH_EMAIL_CLICKED_FORGOT_PASSWORD];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"email" : email.text
                                 };
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"send device token JSON: %@", responseObject);
        // save the user token from the server
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSString *error_message = [responseDictionary objectForKey:@"error_message"];
        if ([error_message isEqualToString:@"SUCCESS"]) {
            RequestForNewPasswordViewController *vc = [[RequestForNewPasswordViewController alloc] initWithEmail:self->email.text];
            UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:navigation animated:YES completion:^{
                NSLog(@"Completed");
            }];
        }
        
        if ([error_message isEqualToString:@"EMAIL_DOES_NOT_EXIST"]) {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Email doesn't exist"
                                         message:@"This email doesn't exist."
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        [self->_activityIndicator stopAnimating];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void) showForgotPasswordPopup {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Password Reset"
                                 message:@"You are going to receive password reset code in your email id Using this reset code you will be able to reset your password"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Send"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    
                                    [self sendPasswordResetKey];
                                }];
    
    
    UIAlertAction* cancel = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   //[LoggingHelper reportLogsDataToAnalytics:CHANGED_PHONE_NO];
                               }];
    
    [cancel setValue:[UIColor grayColor] forKey:@"titleTextColor"];
    [alert addAction:cancel];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
    
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
