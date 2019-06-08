//
//  ProviderElementView.h
//  ReadLet
//
//  Created by Nagendra on 5/16/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Provider.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProviderElementViewDelegate;

@interface ProviderElementView : UIView

-(id)initWithDataModel:(Provider *)news_letter;




@property (nonatomic, weak) id <ProviderElementViewDelegate> delegate;

@end

@protocol ProviderElementViewDelegate <NSObject>
- (void) onProviderClick:(NSInteger ) provider_id isHidden:(BOOL)is_hidden;
- (void) onInfoClick:(NSString *) name  description:(NSString *)description;

@end




NS_ASSUME_NONNULL_END
