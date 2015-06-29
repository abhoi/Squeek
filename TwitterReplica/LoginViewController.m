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

@interface LoginViewController ()
{
    __weak IBOutlet UIButton *btnLogin;
    
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

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
