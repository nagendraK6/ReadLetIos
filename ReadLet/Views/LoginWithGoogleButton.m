//
//  LoginWithGoogleButton.m
//  ReadLet
//
//  Created by Nagendra on 6/16/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "LoginWithGoogleButton.h"

@implementation LoginWithGoogleButton
{
    UIImageView *google_logo;
    UILabel *blue_label;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        google_logo = [[UIImageView alloc] init];
        google_logo.image = [UIImage imageNamed:@"google_logo"];
        [google_logo setContentMode:UIViewContentModeScaleAspectFill];
        
        blue_label = [[UILabel alloc] init];
        blue_label.text = @"Sign up with Google";
        blue_label.textAlignment = NSTextAlignmentCenter;
        [blue_label setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:18]];
        blue_label.textColor = [UIColor whiteColor];
        blue_label.backgroundColor = [UIColor colorWithRed:66.0f/255.0f
                                                     green:133.0f/255.0f
                                                      blue:244.0f/255.0f
                                                     alpha:1.0f];
        [self addSubview:blue_label];
        [self addSubview:google_logo];
        
        

        [self setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *clickInfo =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:clickInfo];
        
        
        CALayer *border = [CALayer layer];
        border.borderWidth = 1;
        [self.layer addSublayer:border];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    blue_label.frame = CGRectMake(0, 0, self.frame.size.width, 60);
    google_logo.frame = CGRectMake(0 , 0, 60, 60);
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.delegate onClick];
}

@end
