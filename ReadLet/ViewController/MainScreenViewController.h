//
//  MainScreenViewController.h
//  ReadLet
//
//  Created by Nagendra on 5/6/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsLetterElementView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainScreenViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, NewsLetterElementViewDelegate>
@end
NS_ASSUME_NONNULL_END

