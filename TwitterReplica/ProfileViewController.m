//
//  ProfileViewController.m
//  TwitterReplica
//
//  Created by Amlaan Bhoi on 7/1/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import "ProfileViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "UserProfileModal.h"
#import "UIImageView+AFNetworking.h"
#import "Chameleon.h"
#include "SWRevealViewController.h"

@interface ProfileViewController ()

@property UserProfileModal *currentUser;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self makeAPIRequest];
}

#pragma mark - Custom Methods
-(void)appearance
{
    
    self.title = NSLocalizedString(@"Timeline", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    
    //[revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    //self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.revealViewController.navigationItem.leftBarButtonItem = revealButtonItem;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) makeAPIRequest {
    // request API
    NSString *url = @"https://api.twitter.com/1.1/users/show.json";
    NSDictionary *param = @{@"user_id" : [[[Twitter sharedInstance] session] userID]};
    NSError *error;
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:url parameters:param error:&error];
    
    [[[Twitter sharedInstance] APIClient]sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (response) {
            id responseData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            UserProfileModal *user = [[UserProfileModal alloc] initWithData:responseData];
            _currentUser = user;
            UIImage *userProfileTemp = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:user.userProfileImg]];
            UIImage *userBannerTemp;
            if (_currentUser.userBannerImg == nil) {
                userBannerTemp = [UIImage imageNamed:@"default_banner"];
            } else {
                userBannerTemp = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:user.userBannerImg]];
            }
            MBTwitterScroll *myTableView = [[MBTwitterScroll alloc] initTableViewWithBackgound:userBannerTemp avatarImage:userProfileTemp titleString:[user screenName] subtitleString:[user userName] buttonTitle:@"Follow"];
            myTableView.tableView.delegate = self;
            myTableView.tableView.dataSource = self;
            myTableView.delegate = self;
            myTableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:myTableView];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[connectionError localizedDescription] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width {
    font = [UIFont systemFontOfSize:16];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat area = size.height * size.width;
    CGFloat height = roundf(area / width);
    return ceilf(height / font.lineHeight) * font.lineHeight;
}

#pragma mark - MBTwitterScrollDelegate
-(void) recievedMBTwitterScrollEvent {
    NSLog(@"ReceivedMBTwitterScrollEvent");
}

- (void)recievedMBTwitterScrollButtonClicked {
    NSLog(@"Button clicked");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int totalheight = 40;
    if (indexPath.row == 0) {
        int height = [self heightForText:_currentUser.userDescription font:nil withinWidth:tableView.bounds.size.width - 30];
        return totalheight += height;
    } else if (indexPath.row == 6) {
        int height = [self heightForText:_currentUser.createdAt font:nil withinWidth:tableView.bounds.size.width - 30];
        return totalheight += height;
    }
    return totalheight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    cell.backgroundColor = [UIColor flatBlackColorDark];
    cell.textLabel.textColor = [UIColor flatWhiteColor];
    NSString *temp;
    NSString *followerCount = [[NSString alloc] initWithFormat:@"%@", _currentUser.followersCount];
    NSString *followingCount = [[NSString alloc] initWithFormat:@"%@", _currentUser.followingCount];
    NSString *listedCount = [[NSString alloc] initWithFormat:@"%@", _currentUser.listedCount];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *created = [dateFormatter dateFromString:_currentUser.createdAt];
    [dateFormatter setDateFormat:@"eee dd MMM yyyy"];
    NSString *created2 = [dateFormatter stringFromDate:created];
    
    switch (indexPath.row) {
        case 0:
            temp = [[NSString alloc] initWithString:_currentUser.userDescription];
            cell.textLabel.numberOfLines = 0;
            [cell.textLabel sizeToFit];
            cell.textLabel.text = temp;
            break;
        case 1:
            temp = [[NSString alloc] initWithString:_currentUser.location];
            cell.textLabel.text = temp;
            break;
        case 2:
            temp = [[NSString alloc] initWithString:_currentUser.profileURL];
            cell.textLabel.text = temp;
            break;
        case 3:
            temp = [NSString stringWithFormat:@"Followers"];
            cell.textLabel.text = temp;
            cell.detailTextLabel.text = followerCount;
            break;
        case 4:
            temp = [NSString stringWithFormat:@"Following"];
            cell.textLabel.text = temp;
            cell.detailTextLabel.text = followingCount;
            break;
        case 5:
            temp = [NSString stringWithFormat:@"Listed"];
            cell.textLabel.text = temp;
            cell.detailTextLabel.text = listedCount;
            break;
        case 6:
            temp = [NSString stringWithFormat:@"Member since"];
            cell.textLabel.numberOfLines = 0;
            [cell.textLabel sizeToFit];
            cell.textLabel.text = temp;
            cell.detailTextLabel.text = created2;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            break;
        default:
            break;
    }
    return cell;
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
