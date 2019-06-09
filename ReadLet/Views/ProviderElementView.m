//
//  ProviderElementView.m
//  ReadLet
//
//  Created by Nagendra on 5/16/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "ProviderElementView.h"
#import "SDWebImage.h"


@implementation ProviderElementView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

{
    UILabel *title;
    UILabel *follow_following;
    Provider *elm;
    UIImageView *creator_image;
    UIImageView *selected_icon;
    UIImageView *info_icon;
    BOOL is_selected;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)initWithDataModel:(Provider *)provider  {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        follow_following = [[UILabel alloc] init];
        elm = provider;
        is_selected = provider.is_subscribed;
        
        creator_image = [[UIImageView alloc] init];
        creator_image.image = [UIImage imageNamed:provider.image_url];
        if (![provider.image_url isEqualToString:@""]) {
            [creator_image sd_setImageWithURL:[NSURL URLWithString:provider.image_url]];
            creator_image.contentMode = UIViewContentModeScaleAspectFit;
        }
        
        
        selected_icon= [[UIImageView alloc] init];
        selected_icon.image = [UIImage imageNamed:@"selected"];

        info_icon = [[UIImageView alloc] init];
        info_icon.image = [UIImage imageNamed:@"info"];

        
        title = [[UILabel alloc] init];
        title.text = [NSString stringWithFormat:@"%@", provider.name];
        title.textColor = [UIColor blackColor];
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.numberOfLines = 0;
        title.font = [UIFont systemFontOfSize:13.0];
        title.textAlignment = NSTextAlignmentLeft;
        
        if (is_selected == YES) {
            selected_icon.hidden = NO;
            follow_following.text = @"Following";
            follow_following.textColor = [UIColor lightGrayColor];
        } else {
            selected_icon.hidden = YES;
            follow_following.text = @"+ Follow";
            follow_following.textColor =   [UIColor colorWithRed:00.0f/255.0f
                                                             green:119.0f/255.0f
                                                              blue:181.0f/255.0f
                                                            alpha:1.0f];
        }
        
        
        
        [self addSubview:creator_image];
        [self addSubview:title];
        [self addSubview:selected_icon];
        [self addSubview:follow_following];

        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleFingerTap];
        
        
        follow_following.userInteractionEnabled=  YES;
        [follow_following addGestureRecognizer:singleFingerTap];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *clickInfo =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(onInfoClick:)];
        [self addGestureRecognizer:clickInfo];
        
        
        // Bottom border

        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    creator_image.frame =  CGRectMake(16, 10, 50, 50);
    //selected_icon.frame =  CGRectMake(self.frame.size.width - 25, 100 , 20, 20);
    title.frame = CGRectMake(16+ 50 + 16, 0 , self.frame.size.width - 82, self.frame.size.height);
    follow_following.frame = CGRectMake(self.frame.size.width - 100, 0, 100, self.frame.size.height);
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, title.frame.size.height - 1, title.frame.size.width, 0.5f);
    bottomBorder.backgroundColor =
    [UIColor colorWithRed:97.0f/255.0f
                    green:97.0f/255.0f
                     blue:97.0f/255.0f
                    alpha:1.0f].CGColor;
    
    [title.layer addSublayer:bottomBorder];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if (is_selected == YES) {
        is_selected = NO;
        follow_following.text = @"+ Follow";
        follow_following.textColor = [UIColor colorWithRed:00.0f/255.0f
                        green:119.0f/255.0f
                         blue:181.0f/255.0f
                        alpha:1.0f];
    } else {
        is_selected = YES;
        follow_following.textColor = [UIColor lightGrayColor];
        follow_following.text = @"Following";
    }
    [self.delegate onProviderClick:elm.provider_id isHidden:!is_selected];
}

- (void) onInfoClick:(UITapGestureRecognizer *)recognizer {
    [self.delegate onInfoClick:elm.name description:elm.details];
}

@end
