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
#import "CINBouncyButton.h"

@interface LoginViewController ()
{
    __weak IBOutlet UIButton *btnLogin;
    
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *buttonImage = [UIImage imageNamed:@"icon_twitter"];
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"Login" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    CINBouncyButton *twitterButton = [[CINBouncyButton alloc] initWithFrame:CGRectMake(40.0f, 40.0f, 250.0f, 40.0f) image:buttonImage andTitle:buttonTitle];
    [twitterButton addTarget:self action:@selector(loginTwitter) forControlEvents:UIControlEventTouchUpInside];
    twitterButton.center = self.view.center;
    [twitterButton setBackgroundColor:[UIColor darkGrayColor]];
    [self.view addSubview:twitterButton];
    [super viewDidLoad];
}

-(void)loginTwitter
{
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error) {
         if (session) {
             NSLog(@"signed in as %@", [session userName]);
             TweetsViewController *tweets = [[TweetsViewController alloc]init];
             [self.navigationController pushViewController:tweets animated:YES];
         } else {
             NSLog(@"error: %@", [error localizedDescription]);
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginTwitter:(UIButton *)sender {
    [self loginTwitter];
}



@end
