//
//  Provider.h
//  ReadLet
//
//  Created by Nagendra on 5/16/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Provider : NSObject

@property (nonatomic, assign) NSInteger provider_id;

@property (nonatomic, assign) BOOL is_subscribed;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *image_url;


@end

NS_ASSUME_NONNULL_END
