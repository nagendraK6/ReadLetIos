//
//  RequestForNotificationViewController.h
//  ReadLet
//
//  Created by Nagendra on 6/11/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "Constants.h"
#import "AFNetworking.h"
#import "RequestForNotificationViewController.h"
#import "RequestForNewPasswordViewController.h"

@interface RequestForNewPasswordViewController ()

@end

@implementation RequestForNewPasswordViewController
{
    UILabel *title;
    UIImageView *next;
    UITextField *password_reset_code;
    UITextField *email;
    UITextField *password;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    email.frame = CGRectMake(48, 170, self.view.frame.size.width - 96, 52);
    password_reset_code.frame = CGRectMake(48, 230, self.view.frame.size.width - 96, 52);
    password.frame = CGRectMake(48, 350, self.view.frame.size.width - 96, 52);
    
    next.frame = CGRectMake(self.view.frame.size.width /2 - 75, 420, 151, 48);
    title.frame = CGRectMake(16, 100, self.view.frame.size.width - 96, 61);
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12.5, 20)];
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12.5, 20)];
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12.5, 20)];
    
    
    
    
    email.layer.cornerRadius = 8.0f;
    email.layer.borderWidth = 1.0f;
    email.layer.borderColor = [UIColor lightGrayColor].CGColor;
    email.layer.masksToBounds = YES;
    
    email.leftView = paddingView;
    email.leftViewMode = UITextFieldViewModeAlways;
    
    
    password_reset_code.layer.cornerRadius = 8.0f;
    password_reset_code.layer.borderWidth = 1.0f;
    password_reset_code.layer.borderColor = [UIColor lightGrayColor].CGColor;
    password_reset_code.layer.masksToBounds = YES;
    
    password_reset_code.leftView = paddingView1;
    password_reset_code.leftViewMode = UITextFieldViewModeAlways;
    
    
    password.layer.cornerRadius = 8.0f;
    password.layer.borderWidth = 1.0f;
    password.layer.borderColor = [UIColor lightGrayColor].CGColor;
    password.layer.masksToBounds = YES;
    
    password.leftView = paddingView2;
    password.leftViewMode = UITextFieldViewModeAlways;
    [next setUserInteractionEnabled:YES];
    
    
    

    
    [password_reset_code addTarget:self
              action:@selector(textFieldDidChange:)
    forControlEvents:UIControlEventEditingChanged];
    
    [password addTarget:self
                 action:@selector(textFieldDidChange:)
       forControlEvents:UIControlEventEditingChanged];
    
    
    [password_reset_code becomeFirstResponder];
    
    UITapGestureRecognizer *tapGesture = \
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(resetPasswordRequest:)];
    [next addGestureRecognizer:tapGesture];
    
    
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

- (void) resetPasswordRequest:(UITapGestureRecognizer *)tapGesture {
    next.image = [UIImage imageNamed:@"nextgray"];
    [next setUserInteractionEnabled:NO];
    [self sendPasswordReset];
}


- (BOOL) shouldEnable {
    if ([password_reset_code.text  isEqual: @""]) {
        return NO;
    }
    
    if ([password.text  isEqual: @""]) {
        return NO;
    }
    
    return YES;
}

- (instancetype)initWithEmail:(NSString *) email_id
{
    self = [super init];
    if (self) {
        title = [[UILabel alloc] init];
        title.text = @"Sign up with email";
        [title setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:18]];
        title.textColor = [UIColor colorWithRed:74.0f/255.0f
                                          green:74.0f/255.0f
                                           blue:74.0f/255.0f
                                          alpha:1.0f];
        
        
        next = [[UIImageView alloc] init];
        next.image = [UIImage imageNamed:@"nextgray"];
        
        
        
        password_reset_code = [[UITextField alloc] init];
        password_reset_code.placeholder = @"Password reset code";
        
        
        email = [[UITextField alloc] init];
        email.placeholder = @"Email";
        email.text = email_id;
        [email setEnabled:NO];
        
        password = [[UITextField alloc] init];
        password.placeholder = @"Password (must be 8 characters)";
        password.secureTextEntry = YES;
        
        
        
        [self.view addSubview:password_reset_code];
        [self.view addSubview:email];
        [self.view addSubview:password];
        
        [self.view addSubview:title];
        [self.view addSubview:next];
        self.navigationItem.title = @"Step 3 of 4";
    }
    return self;
}


- (void) sendPasswordReset {
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_info = [data objectForKey:@"user_info"];
    NSArray *selected_provider_ids = [user_info objectForKey:@"selected_provider_ids"];
    
    NSString *urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"registration/password_reset"];
    NSURL *URL = [NSURL URLWithString:urlstring];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"provider_ids": selected_provider_ids,
                                 @"email": email.text,
                                 @"password": password.text,
                                 @"password_reset_code": password.text
                                 };
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"send device token JSON: %@", responseObject);
        // save the user token from the server
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSString *error_message = [responseDictionary objectForKey:@"error_message"];
        if ([error_message isEqualToString:@"SUCCESS"]) {
            
            
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
            
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Password reset"
                                         message:@"Your password reset code is incorrect. Try again or you can request again from the below link."
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
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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
