//
//  AppDelegate.h
//  ReadLet
//
//  Created by Nagendra on 5/6/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleSignIn;
@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>


@property (strong, nonatomic) UIWindow *window;


@end

