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

@interface RearViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    __weak IBOutlet UITableView *tblInfo;
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
    [tblInfo setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblInfo setEditing:NO];
    tblInfo.allowsSelection = NO;
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
            UIImage *userProfileTemp = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:user.userProfileImg]];
            UIImage *userBannerTemp;
            if (_currentUser.userBannerImg == nil) {
                userBannerTemp = [UIImage imageNamed:@"default_banner"];
            } else {
                userBannerTemp = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:user.userBannerImg]];
            }
            _imgBannerView.image = userBannerTemp;
            _imgBannerView.contentMode = UIViewContentModeScaleAspectFill;
            _imgBannerView.clipsToBounds = YES;
            _imgBannerView.layer.cornerRadius = _imgBannerView.bounds.size.width * 0.02;
            _imgProfileView.image = userProfileTemp;
            _imgProfileView.clipsToBounds = YES;
            _imgProfileView.layer.cornerRadius=_imgProfileView.bounds.size.width/2;
            [tblInfo reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[connectionError localizedDescription] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    cell.backgroundColor = [UIColor flatBlackColorDark];
    cell.textLabel.textColor = [UIColor flatWhiteColor];
    NSString *temp;
    switch (indexPath.row) {
        case 0:
            temp = [[NSString alloc] initWithFormat:@"Tweets"];
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@", _currentUser.statusesCount];
            cell.textLabel.text = temp;
            break;
        case 1:
            temp = [[NSString alloc] initWithFormat:@"Followers"];
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@", _currentUser.followersCount];
            cell.textLabel.text = temp;
            break;
        case 2:
            temp = [[NSString alloc] initWithFormat:@"Following"];
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@", _currentUser.followingCount];
            cell.textLabel.text = temp;
            break;
        case 3:
            temp = [[NSString alloc] initWithFormat:@"Listed"];
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@", _currentUser.listedCount];
            cell.textLabel.text = temp;
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
