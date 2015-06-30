//
//  TweetsModal.m
//  TwitterReplica
//
//  Created by Vaibhav Kumar on 6/29/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import "TweetsModal.h"


@implementation TweetsModal


- (id) initWithData:(NSDictionary *)receivedDict {
    self.createdAt = [receivedDict objectForKey:@"created_at"];
    self.text = [receivedDict objectForKey:@"text"];
    self.tweetID = [receivedDict objectForKey:@"id_str"];
    self.favoriteCount = [receivedDict objectForKey:@"favorite_count"];
    self.retweetCount = [receivedDict objectForKey:@"retweet_count"];
//    self.favorited = [receivedDict objectForKey:@"favorited"];
//    self.display_url = [receivedDict objectForKey:@"display_url"];
    if ([[receivedDict objectForKey:@"entities"] objectForKey:@"media"]) {
        self.mediaUrl = [[NSURL alloc] initWithString:[[[[receivedDict objectForKey:@"entities"] objectForKey:@"media"] objectAtIndex:0] objectForKey:@"media_url_https"]];
    }
    self.profileImg = [[receivedDict objectForKey:@"user"] objectForKey:@"profile_image_url_https"];
    NSLog(@"%@", self.profileImg);
    
    self.name = [[receivedDict objectForKey:@"user"] objectForKey:@"name"];
    self.screenName = [[receivedDict objectForKey:@"user"] objectForKey:@"screen_name"];
    
    /*if ([[receivedDict objectForKey:@"entities"] objectForKey:@"urls"]) {
     self.display_url = [[[[receivedDict objectForKey:@"entities"] objectForKey:@"urls"] objectAtIndex:0] objectForKey:@"display_url"];
     }*/
    
    [self printData];
    return self;
}

- (void) printData {
    NSLog(@"Created At: %@", self.createdAt);
    NSLog(@"Text: %@", self.text);
    NSLog(@"Tweet ID: %@", self.tweetID);
    /*NSLog(@"Favorite Count: %@", self.favorite_count);
     NSLog(@"Retweet Count: %@", self.retweet_count);
     NSLog(@"Favorited?: %@", self.favorited);
     NSLog(@"Media URL: %@", self.media_url_https);
     NSLog(@"Display URL: %@\n", self.display_url);*/
}

@end
