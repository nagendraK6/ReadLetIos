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

@interface SubscribeNewsletterViewController ()

@end

@implementation SubscribeNewsletterViewController
{
    UICollectionView *_collectionView;
    NSMutableArray *all_providers;
    NSMutableArray *selected_provider_ids;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view did load");
    // Do any additional setup after loading the view.
}


-(void)rightBtnClick{
    if ([selected_provider_ids count] == 0) {
        [self showAlert];
    } else {
        // send to server for subscribing the newsletter and open main screen
        [self sendToServer];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        all_providers = [[NSMutableArray alloc] init];
        selected_provider_ids = [[NSMutableArray alloc] init];
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        [layout setMinimumLineSpacing:10.0f];
        _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.frame = CGRectMake(0 , 80 ,self.view.bounds.size.width ,self.view.bounds.size.height-50);
        
        
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
        [self.view addSubview:_collectionView];
        
        UIBarButtonItem *next_button = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
        self.navigationItem.rightBarButtonItem=next_button;
        self.navigationItem.title = @"Subscribe Newsletters";

        
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
    
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    
    
    [cell.contentView addSubview:new_element];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 2; //Replace the divisor with the column count requirement. Make sure to have it in float.
    //CGFloat screenHeight = screenRect.size.height;
    //float cellHeight = screenHeight/3.0;
    

    
    CGSize size = CGSizeMake(cellWidth - 20, 125);
    return size;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10,0,10);
}

- (void) cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) fetchData {
    NSString *urlstring =  [NSString stringWithFormat: APP_URL_WITH_PARAM,@"newsletters/providers"];
    NSURL *URL = [NSURL URLWithString:urlstring];
    
    
    
    
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_info = [data objectForKey:@"user_info"];
    NSString *user_token = [user_info objectForKey:@"user_token"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", user_token] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSArray *message_data = (NSArray *)responseObject;
        NSMutableArray *all_providers_data = [[NSMutableArray alloc] init];
        
        for (id message_c in message_data) {
            NSString  *provider_name = [message_c objectForKey:@"provider_name"];
            NSString *provider_url = [message_c objectForKey:@"provider_url"];
            NSInteger provider_id = [[message_c objectForKey:@"provider_id"] integerValue];
            Boolean is_subscribed = [[message_c objectForKey:@"is_subscribed"] boolValue];

            Provider *a = [[Provider alloc] init];
            a.name = provider_name;
            a.image_url = provider_url;
            a.provider_id = provider_id;
            a.is_subscribed = is_subscribed;
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



@end

