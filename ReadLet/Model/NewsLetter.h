//
//  NewsLetter.h
//  ReadLet
//
//  Created by Nagendra on 5/6/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsLetter : NSObject

@property (strong, nonatomic) NSString *article_title;

@property (strong, nonatomic) NSString *artcile_sub_title;

@property (strong, nonatomic) NSString *article_asset_name;

@property (strong, nonatomic) NSString *article_center_image_name;

@property (strong, nonatomic) NSString *url_for_content;


@end

NS_ASSUME_NONNULL_END
