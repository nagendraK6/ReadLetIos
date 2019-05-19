//
//  HeaderView.m
//  ReadLet
//
//  Created by Nagendra on 5/19/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
{
    UIImageView *headerimage;
    UILabel *title;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        headerimage = [[UIImageView alloc] init];
        headerimage.image = [UIImage imageNamed:@"header"];
        
        title = [[UILabel alloc] init];
        title.text = @"Readlet";
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:36];
        title.textColor = [UIColor colorWithRed:74.0f/255.0f
                                          green:74.0f/255.0f
                                           blue:74.0f/255.0f
                                          alpha:1.0f];
        
        [self addSubview:headerimage];
        [self addSubview:title];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    headerimage.frame = CGRectMake(self.frame.size.width /2 - 105 , 0, 30, 30);
    title.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
