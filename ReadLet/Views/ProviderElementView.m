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
        title.textColor = [UIColor grayColor];
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.numberOfLines = 0;
        title.font = [UIFont systemFontOfSize:13.0];
        title.textAlignment = NSTextAlignmentCenter;
        
        if (is_selected == YES) {
            selected_icon.hidden = NO;
        } else {
            selected_icon.hidden = YES;
        }
        
        [self addSubview:creator_image];
        [self addSubview:title];
        [self addSubview:selected_icon];
        [self addSubview:info_icon];

        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleFingerTap];
        
        
        info_icon.userInteractionEnabled = YES;
        UITapGestureRecognizer *clickInfo =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(onInfoClick:)];
        [info_icon addGestureRecognizer:clickInfo];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    creator_image.frame =  CGRectMake(self.frame.size.width /2 -25, 20, 50, 50);
    selected_icon.frame =  CGRectMake(self.frame.size.width - 25, 100 , 20, 20);
    info_icon.frame = CGRectMake(5, 5 , 20, 20);
    title.frame = CGRectMake(0, 85, self.frame.size.width, 15);
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if (is_selected == YES) {
        is_selected = NO;
        selected_icon.hidden = YES;
    } else {
        is_selected = YES;
        selected_icon.hidden = NO;
    }
    [self.delegate onProviderClick:elm.provider_id isHidden:!is_selected];
}

- (void) onInfoClick:(UITapGestureRecognizer *)recognizer {
    [self.delegate onInfoClick:elm.name description:elm.details];
}

@end
