//
//  RearViewController.m
//  TwitterReplica
//
//  Created by Amlaan Bhoi on 7/2/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import "RearViewController.h"
#include "Chameleon.h"
#import "UserProfileModal.h"
#include <TwitterKit/TwitterKit.h>
#include "AppDelegate.h"
#include "TweetsViewController.h"
#import "UserTimelineViewController.h"
#import "MentionsViewController.h"
#import "ProfileViewController.h"

@interface RearViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    __weak IBOutlet UITableView *tblInfo;
    NSInteger *selectedRow;
}
@property UserProfileModal *currentUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfileView;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgBannerView;
@end

@implementation RearViewController

- (void)willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"willmovetoparentviewcontroller");
    [self makeAPIRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _lblUserName.text = [[NSString alloc] initWithFormat:@"@%@", [[[Twitter sharedInstance] session] userName]];
    [self.view bringSubviewToFront:_imgProfileView];
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor blackColor]];
    [tblInfo setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblInfo setEditing:NO];
    //tblInfo.allowsSelection = NO;
    [self makeAPIRequest];
}

- (void) viewDidAppear:(BOOL)animated {
    [self makeAPIRequest];
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
            _lblScreenName.text = _currentUser.screenName;
            
            [_imgProfileView setImageWithURLRequest:[NSURLRequest requestWithURL:user.userProfileImg] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                _imgProfileView.image = image;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
                singleTap.numberOfTapsRequired = 1;
                singleTap.numberOfTouchesRequired = 1;
                [_imgProfileView setUserInteractionEnabled:YES];
                [_imgProfileView addGestureRecognizer:singleTap];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                _imgProfileView.image = nil;
            }];
            
            [_imgBannerView setImageWithURLRequest:[NSURLRequest requestWithURL:user.userBannerImg] placeholderImage:[UIImage imageNamed:@"default_banner"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                _imgBannerView.image = image;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                _imgBannerView.image = [UIImage imageNamed:@"default_banner"];
            }];
            
            _imgBannerView.contentMode = UIViewContentModeScaleAspectFill;
            _imgBannerView.clipsToBounds = YES;
            _imgBannerView.layer.cornerRadius = _imgBannerView.bounds.size.width * 0.02;
            _imgProfileView.clipsToBounds = YES;
            _imgProfileView.layer.cornerRadius=_imgProfileView.bounds.size.width/2;
            [tblInfo reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[connectionError localizedDescription] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void) tapImage: (UITapGestureRecognizer *) singleTap {
    UIViewController *newFrontViewController = [[ProfileViewController alloc] init];
    [[UINavigationBar appearance] setTintColor:[UIColor flatWhiteColor]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontViewController];
    [self.revealViewController pushFrontViewController:navigationController animated:YES];
    selectedRow = 9;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *newFrontViewController = nil;
    [[UINavigationBar appearance] setTintColor:[UIColor flatWhiteColor]];
    if (indexPath.row == selectedRow)
    {
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
    switch (indexPath.row) {
        case 0:
            newFrontViewController = [[TweetsViewController alloc] init];
            break;
        case 1:
            newFrontViewController = [[MentionsViewController alloc] init];
            break;
        case 2:
            newFrontViewController = [[UserTimelineViewController alloc] init];
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        default:
            break;
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontViewController];
    [self.revealViewController pushFrontViewController:navigationController animated:YES];
    selectedRow = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    cell.backgroundColor = [UIColor flatBlackColorDark];
    cell.textLabel.textColor = [UIColor flatWhiteColor];
    NSString *temp;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Home";
            break;
        case 1:
            cell.textLabel.text = @"Mentions";
            break;
        case 2:
            temp = [[NSString alloc] initWithFormat:@"Tweets"];
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@", _currentUser.statusesCount];
            cell.textLabel.text = temp;
            break;
        case 3:
            temp = [[NSString alloc] initWithFormat:@"Followers"];
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@", _currentUser.followersCount];
            cell.textLabel.text = temp;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            break;
        case 4:
            temp = [[NSString alloc] initWithFormat:@"Following"];
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@", _currentUser.followingCount];
            cell.textLabel.text = temp;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            break;
        case 5:
            temp = [[NSString alloc] initWithFormat:@"Listed"];
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@", _currentUser.listedCount];
            cell.textLabel.text = temp;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            break;
        default:
            break;
    }
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor flatBlackColor];
    cell.selectedBackgroundView = selectionColor;
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
