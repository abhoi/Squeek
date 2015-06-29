//
//  TweetsViewController.m
//  TwitterReplica
//
//  Created by Vaibhav Kumar on 6/29/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import "TweetsViewController.h"
#import <TwitterKit/TwitterKit.h>

@interface TweetsViewController ()

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *url = @"https://api.twitter.com/1.1/statuses/home_timeline.json";
    NSDictionary *param = @{@"count" : @"1"};
    
    NSError *error;
    
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:url parameters:param error:&error];
    
    [[[Twitter sharedInstance] APIClient]sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        
        
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
