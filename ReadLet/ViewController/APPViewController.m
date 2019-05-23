//
//  APPViewController.m
//  ReadLet
//
//  Created by Nagendra on 5/21/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "APPViewController.h"
#import "APPChildViewController.h"

@interface APPViewController ()

@end

@implementation APPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    APPChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pageController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES completion:nil];
    });
    */
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(APPChildViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(APPChildViewController *)viewController index];
    
    
    index++;
    
    if (index == 5) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (APPChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    APPChildViewController *childViewController = [[APPChildViewController alloc] initWithNibName:@"APPChildViewController" bundle:nil];
    childViewController.index = index;
    
    return childViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
