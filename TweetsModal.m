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
    
    self.name = [[receivedDict objectForKey:@"user"] objectForKey:@"name"];
    self.screenName = [[receivedDict objectForKey:@"user"] objectForKey:@"screen_name"];
    
    /*if ([[receivedDict objectForKey:@"entities"] objectForKey:@"urls"]) {
     self.display_url = [[[[receivedDict objectForKey:@"entities"] objectForKey:@"urls"] objectAtIndex:0] objectForKey:@"display_url"];
     }*/
    
    self.combinedName = [NSString stringWithFormat:@"%@ @%@", self.name, self.screenName];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE LLL dd hh:mm:ss ZZZZ yyyy"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *created = [dateFormatter dateFromString:_createdAt];
    NSDate *current = [[NSDate  alloc] init];
    NSTimeInterval inter = [current timeIntervalSinceDate:created];
    if (inter < 60) {
        self.timeElapsed = [NSString stringWithFormat:@"%f seconds", inter];
    } else if (inter < 3600) {
        self.timeElapsed = [NSString stringWithFormat:@"%f seconds", (inter / 60)];
    } else if (inter < 86400) {
        self.timeElapsed = [NSString stringWithFormat:@"%f seconds", ((inter / 60) / 60)];
    } else if (inter < 604800) {
        self.timeElapsed = [NSString stringWithFormat:@"%f seconds", (((inter / 60) / 60) / 7)];
    } else if (inter < 2629743.83) {
        self.timeElapsed = [NSString stringWithFormat:@"%f seconds", ((((inter / 60) / 60) / 7) / 4)];
    } else {
        self.timeElapsed = [NSString stringWithFormat:@"%f seconds", (((((inter / 60) / 60) / 7) / 4) / 12)];
    }
    NSLog(@"\n%@\n", self.timeElapsed);
    return self;
}

- (void) printData {
    NSLog(@"Created At: %@", self.createdAt);
    //NSLog(@"Text: %@", self.text);
    //NSLog(@"Tweet ID: %@", self.tweetID);
    /*NSLog(@"Favorite Count: %@", self.favorite_count);
     NSLog(@"Retweet Count: %@", self.retweet_count);
     NSLog(@"Favorited?: %@", self.favorited);
     NSLog(@"Media URL: %@", self.media_url_https);
     NSLog(@"Display URL: %@\n", self.display_url);*/
}

@end
