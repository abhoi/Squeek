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

@interface TweetsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tblTweets;
    uint totalTweets;
    NSMutableArray *arrTweetsModal;
}

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self appearance];
    
    // request API
    NSString *url = @"https://api.twitter.com/1.1/statuses/home_timeline.json";
    NSDictionary *param = @{@"count" : @"10"};
    
    NSError *error;
    
    
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:url parameters:param error:&error];
    
    [[[Twitter sharedInstance] APIClient]sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        
        id responceData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        totalTweets = [responceData count];
        arrTweetsModal = [[NSMutableArray alloc]init];
        for (NSDictionary *dictData in responceData) {
            TweetsModal *modal = [[TweetsModal alloc]initWithData:dictData];
            [arrTweetsModal addObject:modal];
        }
        [tblTweets reloadData];
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
}

-(void)LogOutAction
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"Signing out of: %@",[[[Twitter sharedInstance] session] userName]);
    [[Twitter sharedInstance] logOut];
}

#pragma mark - Table Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetsModal *modal = (TweetsModal *)[arrTweetsModal objectAtIndex:indexPath.row];
    
    if (modal.mediaUrl) {
        return 274;
    }
    return 140;
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



@end
