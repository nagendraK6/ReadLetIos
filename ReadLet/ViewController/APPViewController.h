//
//  APPViewController.h
//  ReadLet
//
//  Created by Nagendra on 5/21/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

@end

NS_ASSUME_NONNULL_END
