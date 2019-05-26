//
//  AppDelegate.m
//  ReadLet
//
//  Created by Nagendra on 5/6/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "MainScreenViewController.h"
#import "SubscribeNewsletterViewController.h"
#import "APPViewController.h"
#import "NameAddRegistrationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UIPageControl *pageControl = [UIPageControl appearance];
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    UIViewController *vc;
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_info = [data objectForKey:@"user_info"];
    
    if (user_info != nil) {
        // read the token
        NSLog(@"Sending for verification");
        NSString *user_token = [user_info objectForKey:@"user_token"];
        if (user_token != nil) {
            NSObject *has_subscribed = [user_info objectForKey:@"has_subscribed"];
            if (has_subscribed != nil) {
                vc = [[MainScreenViewController alloc] init];
            } else {
                vc = [[APPViewController alloc] init];
            }
        } else {
            vc = [[APPViewController alloc] init];
        }
    } else {
        vc = [[APPViewController alloc] init];
        NSLog(@"Load the phone registration view");
    }
    
    self.window.rootViewController = vc;

    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
