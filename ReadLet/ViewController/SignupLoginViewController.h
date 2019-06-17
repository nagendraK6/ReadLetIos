//
//  SignupLoginViewController.h
//  ReadLet
//
//  Created by Nagendra on 6/10/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleSignIn;
#import "LoginWithGoogleButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface SignupLoginViewController : UIViewController <GIDSignInUIDelegate, LoginWithGoogleButtonDelegate>

@end

NS_ASSUME_NONNULL_END
