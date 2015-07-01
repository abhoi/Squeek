//
//  TweetsViewController.m
//  TwitterReplica
//
//  Created by Vaibhav Kumar on 6/29/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import "TweetsViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "TweetCell.h"
#import "LoginViewController.h"
#import "Chameleon.h"

@interface TweetsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tblTweets;
    uint totalTweets;
    NSMutableArray *arrTweetsModal;
    NSString *sinceID;
    NSString *maxID;
    int counter;
}

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self appearance];
    [self makeAPIRequest];
}

- (void) makeAPIRequest {
    // request API
    NSString *url = @"https://api.twitter.com/1.1/statuses/home_timeline.json";
    NSDictionary *param;
    if (sinceID == nil) {
        param = @{@"count" : @"30"};
    } else {
        param = @{@"count" : @"30", @"since_id" : sinceID};
    }
    NSError *error;
    counter = 1;
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:url parameters:param error:&error];
    
    [[[Twitter sharedInstance] APIClient]sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (response) {
            id responseData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            totalTweets = [responseData count];
            arrTweetsModal = [[NSMutableArray alloc]init];
            for (NSDictionary *dictData in responseData) {
                if (counter == 1) {
                    sinceID = [dictData objectForKey:@"id_str"];
                    counter++;
                }
                TweetsModal *modal = [[TweetsModal alloc]initWithData:dictData];
                [arrTweetsModal addObject:modal];
            }
            [tblTweets reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[connectionError localizedDescription] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void) makeMaxIDAPIRequest {
    NSString *url = @"https://api.twitter.com/1.1/statuses/home_timeline.json";
    NSDictionary *param;
    if (maxID == nil) {
        param = @{@"count" : @"30"};
    } else {
        param = @{@"count" : @"30", @"max_id" : maxID};
    }
    NSError *error;
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:url parameters:param error:&error];
    
    [[[Twitter sharedInstance] APIClient]sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (response) {
            id responseData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            totalTweets = [responseData count];
            arrTweetsModal = [[NSMutableArray alloc]init];
            for (NSDictionary *dictData in responseData) {
                TweetsModal *modal = [[TweetsModal alloc]initWithData:dictData];
                [arrTweetsModal addObject:modal];
            }
            maxID = [[responseData objectAtIndex:[responseData count] - 1] objectForKey:@"id_str"];
            [tblTweets setContentOffset:CGPointZero animated:YES];
            [tblTweets reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[connectionError localizedDescription] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)appearance
{
    [tblTweets setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblTweets setAllowsSelection:NO];
    
    NSLog(@"%lu",(unsigned long)[self.navigationController.viewControllers count]);
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"LogOut"
                                                                    style:UIBarButtonItemStylePlain target:self action:@selector(LogOutAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(makeAPIRequest)];
    self.navigationItem.leftBarButtonItem = refreshButton;
    self.navigationController.navigationBar.barTintColor = [UIColor flatBlackColor];
    self.navigationController.navigationBar.alpha = 0.80f;
    self.navigationController.navigationBar.translucent = YES;
}

-(void)LogOutAction
{
    [self.navigationController popViewControllerAnimated:YES];
    /*if ([self.navigationController viewControllers].count == 1) {
        LoginViewController *login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }*/
    
    NSLog(@"Signing out of: %@",[[[Twitter sharedInstance] session] userName]);
    [[Twitter sharedInstance] logOut];
}

//-(CGFloat)getStringHeight:(NSString *)str
//{
//    [self.view layoutIfNeeded];
//    
//    UILabel *lblTmp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tblTweets.bounds.size.width - 74, 20)];
//    [lblTmp setLineBreakMode:NSLineBreakByWordWrapping];
//    [lblTmp setNumberOfLines:0];
//    [lblTmp.text size]
//    
//    return 0;
//}

- (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width {
    font = [UIFont systemFontOfSize:16];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat area = size.height * size.width;
    CGFloat height = roundf(area / width);
    return ceilf(height / font.lineHeight) * font.lineHeight;
}

#pragma mark - Table Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int totalHeight = 215;
    
    TweetsModal *modal = (TweetsModal *)[arrTweetsModal objectAtIndex:indexPath.row];
    
    [self.view layoutIfNeeded];

    int tweetHeight = [self heightForText:modal.text font:nil withinWidth:tblTweets.bounds.size.width - 68];
    
    if (tweetHeight > 21) {
        totalHeight += tweetHeight;
    }
    
    
    if (modal.mediaUrl) {
        return totalHeight;
    }
    return totalHeight - 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return totalTweets;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"tweetsCell";
    
    TweetCell *cell = (TweetCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil] objectAtIndex:0];
    }
    
    [cell feedTweetData:(TweetsModal *)[arrTweetsModal objectAtIndex:indexPath.row]];
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate
{
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    if(y > h + reload_distance) {
        [self makeMaxIDAPIRequest];
    }
}

@end
