//
//  NewsElementProviderTitleView.m
//  ReadLet
//
//  Created by Nagendra on 5/10/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "NewsElementProviderTitleView.h"

@implementation NewsElementProviderTitleView
{
    UILabel *title;
    UIImage *img;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)initWithText:(NSString *)title_text  {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        title = [[UILabel alloc] init];
        title.text = title_text;
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    title.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
