//
//  LoginWithGoogleButton.h
//  ReadLet
//
//  Created by Nagendra on 6/16/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LoginWithGoogleButtonDelegate;

@interface LoginWithGoogleButton : UIView

@property (nonatomic, weak) id <LoginWithGoogleButtonDelegate> delegate;

@end

@protocol LoginWithGoogleButtonDelegate <NSObject>
- (void) onClick;
@end



NS_ASSUME_NONNULL_END
