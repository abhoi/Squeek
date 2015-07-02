//
//  ProfileViewController.m
//  TwitterReplica
//
//  Created by Amlaan Bhoi on 7/1/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import "ProfileViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "MLAlertView.h"
#import "UserProfileModal.h"
#import "UIImageView+AFNetworking.h"
#import "Chameleon.h"

@interface ProfileViewController ()

@property UserProfileModal *currentUser;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self makeAPIRequest];
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
            UIImage *userBannerTemp = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:user.userBannerImg]];
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


#pragma mark - MBTwitterScrollDelegate
-(void) recievedMBTwitterScrollEvent {
    NSLog(@"ReceivedMBTwitterScrollEvent");
}

- (void)recievedMBTwitterScrollButtonClicked {
    NSLog(@"Button clicked");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text =  @"Cell";
    return cell;*/
    
    /*NSString *cellIdentifier = [NSString stringWithFormat:@"%li", (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor flatBlackColorDark];
    }*/
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.backgroundColor = [UIColor flatBlackColorDark];
    cell.textLabel.textColor = [UIColor flatWhiteColor];
    NSString *temp;
    switch (indexPath.row) {
        case 0:
            temp = [[NSString alloc] initWithString:_currentUser.userDescription];
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
            temp = [NSString stringWithFormat:@"Followers: %@", _currentUser.followersCount];
            cell.textLabel.text = temp;
            break;
        case 4:
            temp = [NSString stringWithFormat:@"Following: %@", _currentUser.followingCount];
            cell.textLabel.text = temp;
            break;
        case 5:
            temp = [NSString stringWithFormat:@"Listed: %@", _currentUser.listedCount];
            cell.textLabel.text = temp;
            break;
        case 6:
            temp = [NSString stringWithFormat:@"Created At: %@", _currentUser.createdAt];
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
