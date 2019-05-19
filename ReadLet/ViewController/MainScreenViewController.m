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
#import "SubscribeNewsletterViewController.h"
#import "HeaderView.h"

@interface MainScreenViewController ()

@end

@implementation MainScreenViewController
{
    UICollectionView *_collectionView;
    NSMutableArray *all_news_letters_data;
    UIImageView *manage;
    HeaderView *header;

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive)
                                                     name:@"appDidBecomeActive"
                                                   object:nil];
        
        all_news_letters_data = [[NSMutableArray alloc] init];
        manage = [[UIImageView alloc] init];
        manage.image = [UIImage imageNamed:@"manage"];
        header = [[HeaderView alloc] init];

        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        [layout setMinimumLineSpacing:0.0f];
        _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        
        
        _collectionView.frame = CGRectMake(0 , 100 ,self.view.bounds.size.width ,self.view.bounds.size.height-50);
        manage.frame = CGRectMake(self.view.bounds.size.width -50 , 50   ,25 ,25);
        header.frame = CGRectMake(0 , 50   ,self.view.bounds.size.width  ,30);

        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
        [self.view addSubview:_collectionView];
        [self.view addSubview:header];
        [self.view addSubview:manage];

        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [manage addGestureRecognizer:singleFingerTap];
        [manage setUserInteractionEnabled:YES];
        
        
        [self fetchData];
        
    }
    return self;
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    // open subscription controller
    SubscribeNewsletterViewController *vc = [[SubscribeNewsletterViewController alloc] init];
    
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
    
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancelButtonAction:)];
    vc.navigationItem.leftBarButtonItem = doneButton;

    
    
    [self presentViewController:navigation animated:YES completion:^{
        NSLog(@"Completed");
    }];
}

- (void) applicationDidBecomeActive {
    NSLog(@"Fetching data");
    [self fetchData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, 100);
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
    
    
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_info = [data objectForKey:@"user_info"];
    NSString *user_token = [user_info objectForKey:@"user_token"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", user_token] forHTTPHeaderField:@"Authorization"];

    
    
    
    
    NSString *urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"registration/get_my_newsletters"];
    NSURL *URL = [NSURL URLWithString:urlstring];
    
        
    
    [manager POST:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSArray *message_data = (NSArray *)responseObject;
        NSMutableArray *all_letters = [[NSMutableArray alloc] init];

        for (id message_c in message_data) {
            NSString  *message_url = [message_c objectForKey:@"message_url"];
            NSString  *title = [message_c objectForKey:@"title"];
            NSString  *date = [message_c objectForKey:@"date"];
            NSString  *provider_name = [message_c objectForKey:@"provider_name"];
            NSString *provider_url = [message_c objectForKey:@"provider_url"];
            
            NewsLetter *a = [[NewsLetter alloc] init];
            a.article_title = title;
            a.content_date_time = date;
            a.url_for_content = message_url;
            a.article_provider_name = provider_name;
            a.provider_url = provider_url;
            [all_letters addObject:a];
        }
        
        self->all_news_letters_data = all_letters;
        [self->_collectionView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
