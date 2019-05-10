//
//  MainScreenViewController.m
//  ReadLet
//
//  Created by Nagendra on 5/6/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "MainScreenViewController.h"
#import "NewsLetter.h"
#import "NewsLetterElementView.h"
#import "ContentViewController.h"
#import "AFNetworking.h"
#import "Constants.h"
@interface MainScreenViewController ()

@end

@implementation MainScreenViewController
{
    UICollectionView *_collectionView;
    NSMutableArray *all_news_letters_data;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        all_news_letters_data = [[NSMutableArray alloc] init];
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.frame = CGRectMake(0 , 80 ,self.view.bounds.size.width ,self.view.bounds.size.height-50);
        
        
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
        [self.view addSubview:_collectionView];

        [self fetchData];
        
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableArray*) getNewsLetters {
    NSMutableArray *all_letters = [[NSMutableArray alloc] init];
    NewsLetter *a = [[NewsLetter alloc] init];
    NewsLetter *b = [[NewsLetter alloc] init];
    NewsLetter *c = [[NewsLetter alloc] init];
    a.article_center_image_name = @"tc";
    a.article_title = @"Techcrunch Daily";
    a.artcile_sub_title = @"Uber and Lyft drivers are striking ahead of the IPO";
    a.url_for_content = @"https://www.readlet.io/registration/read_email";
    
    b.article_center_image_name = @"yc";
    b.article_title = @"Hacker News";
    b.artcile_sub_title = @"Since 2010, we've put out a weekly newsletter of the best articles on startups, technology, programming, and more. All links are curated by hand from Hacker News";
    b.url_for_content = @"https://www.readlet.io/registration/read_email/kb3dvsmh6a1iqgpaots90a1ikp3h227ejd7dpog1";

    
    c.article_center_image_name = @"gates";
    c.article_title = @"Gates notes";
    c.artcile_sub_title = @"5 Books I love to read";
    c.url_for_content = @"https://www.gatesnotes.com/News-Letter";

    [all_letters addObject:a];
    [all_letters addObject:b];
    [all_letters addObject:c];
    return all_letters;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [all_news_letters_data count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    for (id subview in cell.contentView.subviews) {
        if ([subview isKindOfClass:[NewsLetterElementView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    
    NewsLetter *em = [all_news_letters_data objectAtIndex:indexPath.row];
    NewsLetterElementView *new_element = [[NewsLetterElementView alloc] initWithDataModel:em];
    new_element.frame = cell.bounds;
    new_element.delegate = self;
    [cell.contentView addSubview:new_element];
    
    cell.contentView.layer.cornerRadius = 20.0f;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
    cell.layer.shadowRadius = 2.0f;
    cell.layer.shadowOpacity = 5.0f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width - 30, 350);
}

- (void) onNewsLetterClick:(NSString *)url {
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 1.0;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    ContentViewController *vc = [[ContentViewController alloc] initWithURLString:url];
    
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancelButtonAction:)];
    vc.navigationItem.leftBarButtonItem = doneButton;

    [self presentViewController:navigation animated:YES completion:nil];
}

- (void) cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) fetchData {
    NSString *urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"registration/read_news_letters"];
    NSURL *URL = [NSURL URLWithString:urlstring];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSArray *message_data = (NSArray *)responseObject;
        NSMutableArray *all_letters = [[NSMutableArray alloc] init];

        for (id message_c in message_data) {
            NSString  *message_url = [message_c objectForKey:@"message_url"];
            NSString  *title = [message_c objectForKey:@"title"];

            NewsLetter *a = [[NewsLetter alloc] init];
            a.article_center_image_name = @"tc";
            a.article_title = title;
            a.artcile_sub_title = @"ok";
            a.url_for_content = message_url;
            [all_letters addObject:a];
        }
        
        self->all_news_letters_data = all_letters;
        [self->_collectionView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
