//
//  NewsLetterElementView.h
//  ReadLet
//
//  Created by Nagendra on 5/6/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsLetter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NewsLetterElementViewDelegate;

@interface NewsLetterElementView : UIView

@property (nonatomic, weak) id <NewsLetterElementViewDelegate> delegate;

-(id)initWithDataModel:(NewsLetter *)news_letter;

@end


@protocol NewsLetterElementViewDelegate <NSObject>
- (void) onNewsLetterClick:(NSString *)url title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
