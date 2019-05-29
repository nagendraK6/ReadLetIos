//
//  ContentViewController.h
//  ReadLet
//
//  Created by Nagendra on 5/6/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentViewController : UIViewController<WKNavigationDelegate>

- (id) initWithURLString:(NSString *) url_link title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
