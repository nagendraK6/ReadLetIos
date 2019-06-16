//
//  SignupLoginViewController.m
//  ReadLet
//
//  Created by Nagendra on 6/10/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//


#import "SignupLoginViewController.h"
#import "SignupWithEmailViewController.h"
#import "LoggingHelper.h"
#import "SigninWithEmailViewController.h"

@interface SignupLoginViewController ()

@end

@implementation SignupLoginViewController
{
    GIDSignInButton *signInButton;
    UIImageView *signupWithEmail;
    UILabel *signIn;
    UILabel *title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [GIDSignIn sharedInstance].uiDelegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    signInButton.style = kGIDSignInButtonStyleWide;
    signInButton.frame = CGRectMake(48, self.view.frame.size.height / 2  + 100, self.view.frame.size.width - 96, 100);

    signupWithEmail.frame = CGRectMake(48, self.view.frame.size.height / 2  + 160, self.view.frame.size.width - 96, 61);

    signIn.frame = CGRectMake(48, self.view.frame.size.height / 2  + 225, self.view.frame.size.width - 96, 61);
    title.frame = CGRectMake(16, 100, self.view.frame.size.width - 96, 61);
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
        signInButton = [[GIDSignInButton alloc] init];
        signInButton.colorScheme = kGIDSignInButtonColorSchemeDark;
        
        
        NSString *contactsScope = @"https://www.googleapis.com/auth/contacts.readonly";
        
        NSArray *currentScopes = [GIDSignIn sharedInstance].scopes;
        NSMutableArray *new_scopes = [NSMutableArray arrayWithArray:currentScopes];
        [new_scopes addObject:contactsScope];
        [GIDSignIn sharedInstance].scopes = new_scopes;
        
        
        title = [[UILabel alloc] init];
        title.text = @"Lets get you signed up";
        [title setFont:[UIFont fontWithName:@"ArialT" size:18]];
        title.textColor = [UIColor colorWithRed:74.0f/255.0f
                                                       green:74.0f/255.0f
                                                        blue:74.0f/255.0f
                                                       alpha:1.0f];

        signupWithEmail = [[UIImageView alloc] init];
        signupWithEmail.image = [UIImage imageNamed:@"emailsignup"];

        signIn = [[UILabel alloc] init];
        signIn.text = @"Sign in";
        signIn.textColor = [UIColor colorWithRed:0.00f/255.0f
                                           green:118.00f/255.0f
                                            blue:255.0f/255.0f
                                           alpha:1.0f];
        
        signIn.textAlignment = NSTextAlignmentCenter;
        [signIn setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];

        [self.view addSubview:signInButton];
        [self.view addSubview:signupWithEmail];
        [self.view addSubview:signIn];
        [self.view addSubview:title];
        
        self.navigationItem.title = @"Step 2 of 4";
        signupWithEmail.userInteractionEnabled = YES;
        signIn.userInteractionEnabled = YES;

        UITapGestureRecognizer *tapGesture = \
        [[UITapGestureRecognizer alloc]
         initWithTarget:self action:@selector(signupEmail:)];
        [signupWithEmail addGestureRecognizer:tapGesture];

        
        UITapGestureRecognizer *tapGesture1 = \
        [[UITapGestureRecognizer alloc]
         initWithTarget:self action:@selector(signinEmail:)];
        [signIn addGestureRecognizer:tapGesture1];

        
        [LoggingHelper reportLogsDataToAnalytics:SIGNUP_VIEW_VISIBLE];
    }
    return self;
}


- (void) signupEmail:(UITapGestureRecognizer *)tapGesture {
    [LoggingHelper reportLogsDataToAnalytics:SIGNUP_EMAIL_CLICKED];
    SignupWithEmailViewController *vc = [[SignupWithEmailViewController alloc] init];

    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navigation animated:YES completion:^{
        NSLog(@"Completed");
    }];    
}

- (void) signinEmail:(UITapGestureRecognizer *)tapGesture {
    SigninWithEmailViewController *vc = [[SigninWithEmailViewController alloc] init];
    
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navigation animated:YES completion:^{
        NSLog(@"Completed");
    }];
}


@end
