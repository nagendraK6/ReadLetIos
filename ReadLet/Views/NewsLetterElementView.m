//
//  NewsLetterElementView.m
//  ReadLet
//
//  Created by Nagendra on 5/6/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "NewsLetterElementView.h"
#import "NewsElementProviderTitleView.h"
#import "NewsLetter.h"

@implementation NewsLetterElementView
{
    UILabel *title;
    UILabel *sub_title;
    NewsLetter *elm;
    NewsElementProviderTitleView *top_title;
    UIImageView *creator_image;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithDataModel:(NewsLetter *)news_letter  {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        elm = news_letter;
        
        top_title = [[NewsElementProviderTitleView alloc] initWithText:news_letter.article_provider_name];
        
        creator_image = [[UIImageView alloc] init];
        creator_image.image = [UIImage imageNamed:news_letter.article_center_image_name];
        
        title = [[UILabel alloc] init];
        title.text = news_letter.article_title;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.numberOfLines = 0;

        title.font = [UIFont boldSystemFontOfSize:20];
        
        sub_title = [[UILabel alloc] init];
        sub_title.text = [NSString stringWithFormat:@"By: %@", news_letter.article_provider_name];
        sub_title.lineBreakMode = NSLineBreakByWordWrapping;
        sub_title.numberOfLines = 0;
        sub_title.font = [UIFont systemFontOfSize:13.0];


        [self addSubview:title];
        [self addSubview:sub_title];
        [self addSubview:top_title];
        [self addSubview:creator_image];

        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleFingerTap];

        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    creator_image.frame =  CGRectMake(16, 16, 50, 50);
    title.frame = CGRectMake(100, 16, self.frame.size.width - 100, 55);
    sub_title.frame = CGRectMake(100, 75, self.frame.size.width - 100, 15);
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.delegate onNewsLetterClick:elm.url_for_content];
}

@end
