//
//  ViewController.m
//  TwitterReplica
//
//  Created by Vaibhav Kumar on 6/29/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import "LoginViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "TweetsViewController.h"
#import "UserTimelineViewController.h"
#import "CINBouncyButton.h"
#import "Chameleon.h"

@interface LoginViewController ()
{
    __weak IBOutlet UIButton *btnLogin;
    CINBouncyButton *twitterButton;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[self navigationController] setNavigationBarHidden:YES];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *buttonImage = [UIImage imageNamed:@"icon_twitter"];
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"Login" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    twitterButton = [[CINBouncyButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 250)/2, 40.0f, 250.0f, 40.0f) image:buttonImage andTitle:buttonTitle];
    [twitterButton addTarget:self action:@selector(loginTwitter) forControlEvents:UIControlEventTouchUpInside];
    twitterButton.center = self.view.center;
    [twitterButton setBackgroundColor:[UIColor flatSkyBlueColor]];
    [self.view addSubview:twitterButton];
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [twitterButton setFrame:CGRectMake((self.view.bounds.size.width - 250)/2, (self.view.bounds.size.height - 40)/2, 250.0f, 40.0f)];
}

-(void)loginTwitter
{
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error) {
         if (session) {
             NSLog(@"signed in as %@", [session userName]);
             TweetsViewController *tweets = [[TweetsViewController alloc]init];
             
             //UserTimelineViewController *userTimeline = [[UserTimelineViewController alloc] initWithNibName:@"UserTimelineViewController" bundle:nil];
             
             [self.navigationController pushViewController:tweets animated:YES];
             [[self navigationController] setNavigationBarHidden:NO];
         } else {
             NSLog(@"error: %@", [error localizedDescription]);
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
