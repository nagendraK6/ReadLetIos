//
//  NewsLetterElementView.m
//  ReadLet
//
//  Created by Nagendra on 5/6/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "NewsLetterElementView.h"
#import "NewsLetter.h"

@implementation NewsLetterElementView
{
    UIImageView *cover_image;
    UILabel *title;
    UILabel *sub_title;
    NewsLetter *elm;

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
        cover_image = [[UIImageView alloc] init];
        cover_image.image = [UIImage imageNamed:news_letter.article_center_image_name];
        
        title = [[UILabel alloc] init];
        title.text = news_letter.article_title;
        title.font = [UIFont boldSystemFontOfSize:25];
        
        sub_title = [[UILabel alloc] init];
        sub_title.text = news_letter.artcile_sub_title;
        sub_title.lineBreakMode = NSLineBreakByWordWrapping;
        sub_title.numberOfLines = 0;

        [self addSubview:cover_image];
        [self addSubview:title];
        [self addSubview:sub_title];

        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleFingerTap];

        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    cover_image.frame = CGRectMake(0, 0, self.frame.size.width, 200);
    title.frame = CGRectMake(10, 210, self.frame.size.width, 25);
    sub_title.frame = CGRectMake(10, 235, self.frame.size.width - 15, 100);
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.delegate onNewsLetterClick:elm.url_for_content];
}

@end
