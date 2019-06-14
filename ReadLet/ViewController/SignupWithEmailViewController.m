//
//  SignupWithEmailViewController.m
//  ReadLet
//
//  Created by Nagendra on 6/11/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "SignupWithEmailViewController.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "RequestForNotificationViewController.h"

@interface SignupWithEmailViewController ()

@end

@implementation SignupWithEmailViewController
{
    UILabel *title;
    UIImageView *next;
    UITextField *first_name;
    UITextField *last_name;
    UITextField *email;
    UITextField *password;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    first_name.frame = CGRectMake(48, 170, self.view.frame.size.width - 96, 52);
    last_name.frame = CGRectMake(48, 230, self.view.frame.size.width - 96, 52);
    email.frame = CGRectMake(48, 290, self.view.frame.size.width - 96, 52);
    password.frame = CGRectMake(48, 350, self.view.frame.size.width - 96, 52);

    next.frame = CGRectMake(self.view.frame.size.width /2 - 75, 420, 151, 48);
    title.frame = CGRectMake(16, 100, self.view.frame.size.width - 96, 61);

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12.5, 20)];
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12.5, 20)];

    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12.5, 20)];

    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12.5, 20)];

    
    
    first_name.layer.cornerRadius = 8.0f;
    first_name.layer.borderWidth = 1.0f;
    first_name.layer.borderColor = [UIColor lightGrayColor].CGColor;
    first_name.layer.masksToBounds = YES;
    
    first_name.leftView = paddingView;
    first_name.leftViewMode = UITextFieldViewModeAlways;

    
    last_name.layer.cornerRadius = 8.0f;
    last_name.layer.borderWidth = 1.0f;
    last_name.layer.borderColor = [UIColor lightGrayColor].CGColor;
    last_name.layer.masksToBounds = YES;
    
    last_name.leftView = paddingView1;
    last_name.leftViewMode = UITextFieldViewModeAlways;
    

    email.layer.cornerRadius = 8.0f;
    email.layer.borderWidth = 1.0f;
    email.layer.borderColor = [UIColor lightGrayColor].CGColor;
    email.layer.masksToBounds = YES;
    
    email.leftView = paddingView2;
    email.leftViewMode = UITextFieldViewModeAlways;
    [next setUserInteractionEnabled:YES];
    
    password.layer.cornerRadius = 8.0f;
    password.layer.borderWidth = 1.0f;
    password.layer.borderColor = [UIColor lightGrayColor].CGColor;
    password.layer.masksToBounds = YES;
    
    password.leftView = paddingView3;
    password.leftViewMode = UITextFieldViewModeAlways;
 
    
    [first_name addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    
    
    [last_name addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];

    [email addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];

    [password addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];

    
    [first_name becomeFirstResponder];
    
    UITapGestureRecognizer *tapGesture = \
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(signupEmail:)];
    [next addGestureRecognizer:tapGesture];
    

}

- (void)textFieldDidChange:(UITextField *)textField {
    if([self shouldEnable] == YES) {
        next.image = [UIImage imageNamed:@"nextdark"];
        [next setUserInteractionEnabled:NO];

    } else {
        next.image = [UIImage imageNamed:@"nextgray"];
        [next setUserInteractionEnabled:YES];

    }
}

- (void) signupEmail:(UITapGestureRecognizer *)tapGesture {
}


- (BOOL) shouldEnable {
    if ([first_name.text  isEqual: @""]) {
        return NO;
    }
    
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
        title = [[UILabel alloc] init];
        title.text = @"Sign up with email";
        [title setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:18]];
        title.textColor = [UIColor colorWithRed:74.0f/255.0f
                                          green:74.0f/255.0f
                                           blue:74.0f/255.0f
                                          alpha:1.0f];
        
        
        next = [[UIImageView alloc] init];
        next.image = [UIImage imageNamed:@"nextgray"];
        
        
        
        first_name = [[UITextField alloc] init];
        first_name.placeholder = @"First Name";
        
        last_name = [[UITextField alloc] init];
        last_name.placeholder = @"Last Name";
        
        email = [[UITextField alloc] init];
        email.placeholder = @"Email";
        
        password = [[UITextField alloc] init];
        password.placeholder = @"Password (must be 8 characters)";
        password.secureTextEntry = YES;

        
        
        [self.view addSubview:first_name];
        [self.view addSubview:last_name];
        [self.view addSubview:email];
        [self.view addSubview:password];

        [self.view addSubview:title];
        [self.view addSubview:next];
        self.navigationItem.title = @"Step 3 of 4";
    }
    return self;
}


- (void) sendSignupWithEmail {
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_info = [data objectForKey:@"user_info"];
    NSArray *selected_provider_ids = [user_info objectForKey:@"selected_provider_ids"];
    
    NSString *urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"registration/login_with_email"];
    NSURL *URL = [NSURL URLWithString:urlstring];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"provider_ids": selected_provider_ids,
                                 @"first_name" : first_name.text,
                                 @"last_name" : last_name.text,
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
