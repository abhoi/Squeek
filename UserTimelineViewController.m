//
//  UserTimelineViewController.m
//  TwitterReplica
//
//  Created by Amlaan Bhoi on 7/2/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import "UserTimelineViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "TweetCell.h"
#import "LoginViewController.h"
#import "Chameleon.h"
#import "TweetsDetailsViewController.h"

@interface UserTimelineViewController ()<UITableViewDataSource,UITableViewDelegate, UITabBarControllerDelegate>
{
    __weak IBOutlet UITableView *tblTweets;
    BOOL sinceIDRequestToggle;
    int counter;
    UIRefreshControl *refreshControl;
}
@property NSMutableArray *arrTweetsModal;
@property uint totalTweets;
@property NSString *sinceID;
@property NSString *maxID;

@end

@implementation UserTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _totalTweets = 0;
    _arrTweetsModal = [[NSMutableArray alloc]init];
    [self appearance];
    [self makeAPIRequest];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [tblTweets addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void) refreshTable {
    [self makeAPIRequest];
    [refreshControl endRefreshing];
}

- (void) makeAPIRequest {
    // request API
    NSString *url = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
    NSDictionary *param;
    if (_sinceID == nil) {
        param = @{@"count" : @"30"};
        sinceIDRequestToggle = NO;
    } else {
        param = @{@"count" : @"30", @"since_id" : _sinceID};
        sinceIDRequestToggle = YES;
    }
    NSError *error;
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:url parameters:param error:&error];
    
    [[[Twitter sharedInstance] APIClient]sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (response) {
            id responseData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            _totalTweets += [responseData count];
            if ([responseData count] == 0) {
                NSLog(@"NO new tweets");
                return;
            }
            if (sinceIDRequestToggle == NO) {
                counter = 1;
                for (NSDictionary *dictData in responseData) {
                    if (counter == 1) {
                        _sinceID = [dictData objectForKey:@"id_str"];
                        counter++;
                    }
                    TweetsModal *modal = [[TweetsModal alloc]initWithData:dictData];
                    [_arrTweetsModal addObject:modal];
                }
            } else {
                counter = [responseData count];
                for (NSDictionary *dictData in [responseData reverseObjectEnumerator]) {
                    if (counter == [responseData count]) {
                        _sinceID = [dictData objectForKey:@"id_str"];
                        counter--;
                    }
                    TweetsModal *modal = [[TweetsModal alloc] initWithData:dictData];
                    [_arrTweetsModal insertObject:modal atIndex:0];
                }
            }
            //_maxID = [[responseData objectAtIndex:[responseData count] - 1] objectForKey:@"id_str"];
            TweetsModal *tmp = (TweetsModal *)[_arrTweetsModal objectAtIndex:[_arrTweetsModal count] - 1 ];
            _maxID = [NSString stringWithFormat:@"%@", tmp.tweetID];
            [tblTweets reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[connectionError localizedDescription] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void) makeMaxIDAPIRequest {
    if ([_arrTweetsModal count] > 0) {
        [_arrTweetsModal removeObjectAtIndex:[_arrTweetsModal count] - 1];
    }
    NSString *url = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
    NSDictionary *param;
    if (_maxID == nil) {
        param = @{@"count" : @"30"};
    } else {
        param = @{@"count" : @"30", @"max_id" : _maxID};
    }
    NSError *error;
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:url parameters:param error:&error];
    
    [[[Twitter sharedInstance] APIClient]sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (response) {
            id responseData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            _totalTweets += [responseData count];
            for (NSDictionary *dictData in responseData) {
                TweetsModal *modal = [[TweetsModal alloc]initWithData:dictData];
                [_arrTweetsModal addObject:modal];
            }
            if ([_arrTweetsModal count] > 0) {
                _maxID = [[responseData objectAtIndex:[responseData count] - 1] objectForKey:@"id_str"];
            }
            [tblTweets reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[connectionError localizedDescription] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
    if ([_arrTweetsModal count] > 0) {
        _totalTweets--;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)appearance
{
    [tblTweets setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //[tblTweets setAllowsSelection:NO];
    //self.title = NSLocalizedString(@"Timeline", nil);
    self.title = [[NSString alloc] initWithFormat:@"@%@ Timeline", [[[Twitter sharedInstance] session] userName]];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor flatWhiteColor]};
    SWRevealViewController *revealController = [self revealViewController];
    
    //[revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *composeButtonItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeTweet)];
    self.navigationItem.rightBarButtonItem = composeButtonItem2;
    
    //    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
    //                                                                              style:UIBarButtonItemStylePlain target:revealController action:@selector(rightRevealToggle:)];
    //
    //    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
    
    
    
    /*NSLog(@"%lu",(unsigned long)[self.navigationController.viewControllers count]);
     
     UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"LogOut"
     style:UIBarButtonItemStylePlain target:self action:@selector(LogOutAction)];
     self.navigationItem.rightBarButtonItem = rightButton;
     UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(makeAPIRequest)];
     self.navigationItem.leftBarButtonItem = refreshButton;
     self.navigationController.navigationBar.barTintColor = [UIColor flatBlackColor];
     self.navigationController.navigationBar.alpha = 0.80f;
     self.navigationController.navigationBar.translucent = YES;*/
}

- (void) composeTweet {
    SLComposeViewController *composeV = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [self presentViewController:composeV animated:YES completion:nil];
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
    
    TweetsModal *modal = (TweetsModal *)[_arrTweetsModal objectAtIndex:indexPath.row];
    
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
    return _totalTweets;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"tweetsCell";
    
    TweetCell *cell = (TweetCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil] objectAtIndex:0];
    }
    
    [cell feedTweetData:(TweetsModal *)[_arrTweetsModal objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetsDetailsViewController *tweetsDetails = [[TweetsDetailsViewController alloc]initWithNibName:@"TweetsDetailsViewController" bundle:nil];
    [tweetsDetails setTweetRef:(TweetsModal *)[_arrTweetsModal objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:tweetsDetails animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        NSLog(@"Reached end of table");
        [self makeMaxIDAPIRequest];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
