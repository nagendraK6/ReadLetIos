//
//  SubscribeNewsletterViewController.m
//  ReadLet
//
//  Created by Nagendra on 5/16/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "SubscribeNewsletterViewController.h"
#import "MainScreenViewController.h"
#import "Provider.h"
#import "ProviderElementView.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "PhoneNoAskViewController.h"
#import "LoggingHelper.h"

@interface SubscribeNewsletterViewController ()
{
    BOOL init_standalone;
}
@end

@implementation SubscribeNewsletterViewController
{
    UICollectionView *_collectionView;
    NSMutableArray *all_providers;
    NSMutableArray *selected_provider_ids;
    UILabel *title;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"view did load");
    title.frame = CGRectMake(0, 5, self.view.frame.size.width, 20);
    // Do any additional setup after loading the view.
}


-(void)rightBtnClick{
    if ([selected_provider_ids count] == 0) {
        [self showAlert];
    } else {
        // send to server for subscribing the newsletter and open main screen
        if (init_standalone == NO) {
            [self sendToServer];
        } else {
            // open phone number flow
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *user_info = [defaults objectForKey:@"user_info"];
            NSMutableDictionary *updated_object = [[NSMutableDictionary alloc] initWithDictionary:user_info];
            [updated_object setObject:selected_provider_ids forKey:@"selected_provider_ids"];
            [defaults setObject:updated_object forKey:@"user_info"];
            
            [self openRegFlow];
        }
    }
}

- (instancetype) initWithoutFetch
{
    self = [super init];
    if (self) {
        init_standalone = YES;
        [self setup];
        [self fetchData:NO];
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        init_standalone = NO;
        [self setup];
        [self fetchData:YES];
    }
    return self;
}

- (void) setup {
    all_providers = [[NSMutableArray alloc] init];
    selected_provider_ids = [[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumLineSpacing:0.0f];
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _collectionView.frame = CGRectMake(0 , 100 ,self.view.bounds.size.width ,self.view.bounds.size.height-50);
    
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_collectionView];
    
    NSString *next_title = init_standalone == YES ? @"Next" : @"Save";
    
    UIBarButtonItem *next_button = [[UIBarButtonItem alloc]initWithTitle:next_title style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem=next_button;
    self.navigationItem.title = @"Step 1 of 4";
    
    title = [[UILabel alloc] init];
    title.text = @"Select newsletters from below";
    [self.view addSubview:title];
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
    return [all_providers count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    for (id subview in cell.contentView.subviews) {
        if ([subview isKindOfClass:[ProviderElementView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    
    Provider *em = [all_providers objectAtIndex:indexPath.row];
    ProviderElementView *new_element = [[ProviderElementView alloc] initWithDataModel:em];
    new_element.frame = cell.bounds;
    new_element.delegate = self;
    
    
    
    [cell.contentView addSubview:new_element];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth; //Replace the divisor with the column count requirement. Make sure to have it in float.
    //CGFloat screenHeight = screenRect.size.height;
    //float cellHeight = screenHeight/3.0;
    

    
    CGSize size = CGSizeMake(cellWidth, 70);
    return size;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0,0,0);
}

- (void) cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) fetchData:(BOOL) has_token {
    AFHTTPSessionManager *manager;
    NSString *urlstring;
    if (has_token == YES) {
        urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"newsletters/providers"];
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        NSDictionary *user_info = [data objectForKey:@"user_info"];
        NSString *user_token = [user_info objectForKey:@"user_token"];
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", user_token] forHTTPHeaderField:@"Authorization"];
    } else {
        urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"newsletters/providers_list"];
        
        
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    NSURL *URL = [NSURL URLWithString:urlstring];

    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSArray *message_data = (NSArray *)responseObject;
        NSMutableArray *all_providers_data = [[NSMutableArray alloc] init];
        
        for (id message_c in message_data) {
            NSString  *provider_name = [message_c objectForKey:@"provider_name"];
            NSString  *description = [message_c objectForKey:@"description"];
            NSString *provider_url = [message_c objectForKey:@"provider_url"];
            NSInteger provider_id = [[message_c objectForKey:@"provider_id"] integerValue];
            Boolean is_subscribed = [[message_c objectForKey:@"is_subscribed"] boolValue];

            Provider *a = [[Provider alloc] init];
            a.name = provider_name;
            a.image_url = provider_url;
            a.provider_id = provider_id;
            a.is_subscribed = is_subscribed;
            a.details = description;
            if (a.is_subscribed == YES) {
                NSNumber *number = [NSNumber numberWithInt:provider_id];
                [selected_provider_ids addObject:number];
            }
            
            [all_providers_data addObject:a];
        }
        
        self->all_providers = all_providers_data;
        [self->_collectionView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) onProviderClick:(NSInteger ) provider_id isHidden:(BOOL)is_hidden {
    if(is_hidden == NO) {
        NSNumber *number = [NSNumber numberWithInt:provider_id];
        [selected_provider_ids addObject:number];
    } else {
        NSNumber *number = [NSNumber numberWithInt:provider_id];
        NSInteger index = [selected_provider_ids indexOfObject:number];
        [selected_provider_ids removeObjectAtIndex:index];
    }
}


- (void) onInfoClick:(NSString *) name  description:(NSString *)description {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:name
                                 message:description
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                               }];
    
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:NO completion:nil];
}


- (void) showAlert {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Important"
                                 message:@"Please subscribe to at least one newsletter"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:NO completion:nil];
}


- (void) sendToServer {
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_info = [data objectForKey:@"user_info"];
    NSString *user_token = [user_info objectForKey:@"user_token"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", user_token] forHTTPHeaderField:@"Authorization"];
    
    NSString *urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"newsletters/subscribe"];

    
    NSDictionary *params = @{
                             @"provider_ids": selected_provider_ids
                             };
    

    
    [manager POST:urlstring parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *user_info = [defaults objectForKey:@"user_info"];
        NSMutableDictionary *updated_object = [[NSMutableDictionary alloc] initWithDictionary:user_info];
        
        [updated_object setObject:@YES forKey:@"has_subscribed"];
        [defaults setObject:updated_object forKey:@"user_info"];
        
        
        MainScreenViewController *vc = [[MainScreenViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        //[LoggingHelper reportLogsDataToAnalytics:PHONE_SEND_SERVER_FAILED];
        NSLog(@"Error: %@", error);
    }];
}


- (void) openRegFlow {
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    PhoneNoAskViewController *vc = [[PhoneNoAskViewController alloc] init];
    
    
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navigation animated:YES completion:^{
        NSLog(@"Completed");
    }];
}


@end

