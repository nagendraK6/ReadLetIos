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
#import "LoggingHelper.h"
#import "RequestForNotificationViewController.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "ContentViewController.h"
#import "SignupLoginViewController.h"
#import "SigninWithEmailViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GIDSignIn sharedInstance].clientID = @"126469114432-kjrbi42in68eipug284kns5sqgqm1t67.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].delegate = self;

    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [LoggingHelper initLogsAnalyticsProvider];
    
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




- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    [self sendGoogleLogin:user];
    // send to server
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [LoggingHelper reportLogsDataToAnalytics:APP_BG];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [LoggingHelper reportLogsDataToAnalytics:APP_FG];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Device token %@", token);
    [self sendDeviceIdToServer:token];
    // send device token for registration
}

- (void) sendDeviceIdToServer:(NSString *)deviceId {
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_info = [data objectForKey:@"user_info"];
    NSString *user_token = [user_info objectForKey:@"user_token"];
    
    NSString *urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"registration/add_device_id"];
    NSURL *URL = [NSURL URLWithString:urlstring];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{ @"device_id": deviceId};
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", user_token] forHTTPHeaderField:@"Authorization"];
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"send device token JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) sendGoogleLogin:(GIDGoogleUser *)user {
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_info = [data objectForKey:@"user_info"];
    NSArray *selected_provider_ids = [user_info objectForKey:@"selected_provider_ids"];
    
    NSString *urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"registration/login_with_google"];
    NSURL *URL = [NSURL URLWithString:urlstring];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"provider_ids": selected_provider_ids,
                                 @"access_token" : user.authentication.accessToken,
                                 @"refresh_token" : user.authentication.refreshToken,
                                 @"first_name" : user.profile.givenName,
                                 @"last_name" : user.profile.familyName,
                                 @"email" : user.profile.email
                            };
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"send device token JSON: %@", responseObject);
        // save the user token from the server
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        
        NSDictionary *old_info = [data objectForKey:@"user_info"];
        NSMutableDictionary *user_info = [[NSMutableDictionary alloc] initWithDictionary:old_info];
        
        [user_info setObject:[NSNumber numberWithBool:NO] forKey:@"is_otp_verified"];
        [user_info setObject:[responseDictionary objectForKey:@"user_id"] forKey:@"user_id"];
        [user_info setObject:[responseDictionary objectForKey:@"user_token"] forKey:@"user_token"];
        [user_info setObject:@YES forKey:@"has_subscribed"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:user_info forKey:@"user_info"];
        
        
        RequestForNotificationViewController *vc = [[RequestForNotificationViewController alloc] init];
        UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
        self.window.rootViewController = navigation;
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {

        
        NSLog(@"Error: %@", error);
    }];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"didReceiveRemoteNotification with completionHandler");
    // Must call completion handler
    if (userInfo.count > 0) {
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
    
    if (application.applicationState == UIApplicationStateInactive) {
        if (userInfo.count > 0) {
            NSString *payload_type = [userInfo objectForKey:@"payload_type"];
            if ([payload_type isEqualToString:@"new_newsletter"]) {
                NSString *message_url = [userInfo objectForKey:@"message_url"];
                NSString *title = [userInfo objectForKey:@"title"];
                
                ContentViewController *vc = [[ContentViewController alloc] initWithURLString:message_url title:title];
                
                UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
                
                [LoggingHelper reportLogsDataToAnalytics:CLICKED_NEWSLETTER_NOTIFICATION];

                [self.window.rootViewController presentViewController:navigation animated:YES completion:NULL];
                 NSLog(@"New newsletter received");
            }
        }
    }
    NSLog(@"userInfo:%@", userInfo);
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SEL openDetails = @selector(openDetailsViewFromNotificationInfo:);
        //The below line will removes previous request.
        [NSObject cancelPreviousPerformRequestsWithTarget:strongSelf selector:openDetails object:userInfo];
        //Not neccessary
        [strongSelf performSelector:openDetails withObject:userInfo afterDelay:0.5];
    });
}

-(void)openDetailsViewFromNotificationInfo:(NSDictionary *)userInfo {
    
//    NSLog(@"topVC: %@", topVC);
    //Here BaseViewController is the root view, this will initiate on App launch also.
}


@end
