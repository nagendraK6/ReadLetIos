//
//  APPChildViewController.m
//  ReadLet
//
//  Created by Nagendra on 5/21/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "APPChildViewController.h"

@interface APPChildViewController ()
{
    UILabel *app_name;
    UILabel *title_name;
    UILabel *description;
    UIImageView *_centerLogo;
    
    UIImageView *screen_1_2_img;
    UILabel *screen_1_2_text;
}
@end


@implementation APPChildViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupScreen1];
        [self setupscreen12];
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    if(self.index == 0) {
        [self renderScreen0];
    }
    
    if (self.index == 1) {
        [self renderScreen1];
    }
    
    if (self.index == 2) {
        [self renderScreen2];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)viewDidAppear:(BOOL)animated {
   // self.screenNumber.text = [NSString stringWithFormat:@"Screen #%ld", (long)self.index];
}

- (void) setupScreen1 {
    app_name = [[UILabel alloc] init];
    app_name.text = @"Readlet";
    app_name.textAlignment = NSTextAlignmentCenter;
    app_name.font = [UIFont boldSystemFontOfSize:36];
    app_name.textColor = [UIColor colorWithRed:74.0f/255.0f
                                         green:74.0f/255.0f
                                          blue:74.0f/255.0f
                                         alpha:1.0f];
    
    
    title_name = [[UILabel alloc] init];
    title_name.text = @"Your information diet";
    title_name.textAlignment = NSTextAlignmentCenter;
    title_name.font = [UIFont boldSystemFontOfSize:18];
    title_name.textColor = [UIColor colorWithRed:74.0f/255.0f
                                           green:74.0f/255.0f
                                            blue:74.0f/255.0f
                                           alpha:1.0f];
    
    
    
    description = [[UILabel alloc] init];
    description.text = @"Readlet’s curated newsletters help you make sense of the news  around you";
    description.textAlignment = NSTextAlignmentCenter;
    description.font = [UIFont boldSystemFontOfSize:18];
    description.textColor = [UIColor colorWithRed:79.0f/255.0f
                                            green:111.0f/255.0f
                                             blue:13.0f/255.0f
                                            alpha:1.0f];
    
    description.lineBreakMode = NSLineBreakByWordWrapping;
    description.numberOfLines = 0;
    
    _centerLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"getstarted"]];
    
    
    [self.view addSubview:app_name];
    [self.view addSubview:title_name];
    [self.view addSubview:description];
    [self.view addSubview:_centerLogo];
}


- (void) renderScreen0 {
    _centerLogo.frame = CGRectMake(self.view.frame.size.width /2 - 90, 100 ,180,180);
    app_name.frame = CGRectMake(0, 290 ,self.view.frame.size.width  ,50);
    title_name.frame = CGRectMake(0, 330 ,self.view.frame.size.width  ,30);
    description.frame = CGRectMake(self.view.frame.size.width / 2 - 135, 450 ,270  ,100);
}


- (void) setupscreen12 {
    screen_1_2_img = [[UIImageView alloc] init];
    screen_1_2_text = [[UILabel alloc] init];
    [self.view addSubview:screen_1_2_img];
    [self.view addSubview:screen_1_2_text];

}


- (void) renderScreen1 {
    [_centerLogo setHidden:YES];
    screen_1_2_img.image = [UIImage imageNamed:@"sc2"];
    screen_1_2_img.frame = CGRectMake(self.view.frame.size.width /2 - 125, 100 ,250,250);
    screen_1_2_text.frame = CGRectMake(self.view.frame.size.width / 2 - 175, 450 ,350  ,100);
    
    
    screen_1_2_text.text = @"Subscribe to what the most influential in your industry are reading and writing";
    screen_1_2_text.textAlignment = NSTextAlignmentCenter;
    screen_1_2_text.font = [UIFont boldSystemFontOfSize:18];
    screen_1_2_text.textColor = [UIColor colorWithRed:79.0f/255.0f
                                            green:111.0f/255.0f
                                             blue:13.0f/255.0f
                                            alpha:1.0f];
    
    screen_1_2_text.lineBreakMode = NSLineBreakByWordWrapping;
    screen_1_2_text.numberOfLines = 0;

    

}

- (void) renderScreen2 {
    [_centerLogo setHidden:YES];
    screen_1_2_img.image = [UIImage imageNamed:@"sc3"];
    screen_1_2_img.frame = CGRectMake(self.view.frame.size.width /2 - 125, 100 ,250,250);
    screen_1_2_text.frame = CGRectMake(self.view.frame.size.width / 2 - 135, 450 ,270  ,100);
    
    screen_1_2_text.text = @"Read all in one place and keep your email clutter free";
    screen_1_2_text.textAlignment = NSTextAlignmentCenter;
    screen_1_2_text.font = [UIFont boldSystemFontOfSize:18];
    screen_1_2_text.textColor = [UIColor colorWithRed:79.0f/255.0f
                                                green:111.0f/255.0f
                                                 blue:13.0f/255.0f
                                                alpha:1.0f];
    
    screen_1_2_text.lineBreakMode = NSLineBreakByWordWrapping;
    screen_1_2_text.numberOfLines = 0;
}



@end
