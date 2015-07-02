//
//  UserProfileModal.m
//  TwitterReplica
//
//  Created by Amlaan Bhoi on 7/2/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import "UserProfileModal.h"

@implementation UserProfileModal

- (id)initWithData:(NSDictionary *)receivedDict {
    self.userName = [receivedDict objectForKey:@"screen_name"];
    self.screenName = [receivedDict objectForKey:@"name"];
    
    self.userDescription = [receivedDict objectForKey:@"description"];
    self.location = [receivedDict objectForKey:@"location"];
    self.profileURL = [receivedDict objectForKey:@"url"];
    self.followersCount = [receivedDict objectForKey:@"followers_count"];
    self.followingCount = [receivedDict objectForKey:@"friends_count"];
    self.listedCount = [receivedDict objectForKey:@"listed_count"];
    self.createdAt = [receivedDict objectForKey:@"created_at"];
    self.statusesCount = [receivedDict objectForKey:@"statuses_count"];
    
    NSString *tempUserProfileImg = [receivedDict objectForKey:@"profile_image_url_https"];
    if ([tempUserProfileImg containsString:@"_normal.jpg"]) {
        tempUserProfileImg = [tempUserProfileImg stringByReplacingOccurrencesOfString:@"_normal.jpg" withString:@".jpg"];
    } else if ([tempUserProfileImg containsString:@"_normal.png"]) {
        tempUserProfileImg = [tempUserProfileImg stringByReplacingOccurrencesOfString:@"_normal.png" withString:@".png"];
    } else if ([tempUserProfileImg containsString:@"_normal.jpeg"]) {
        tempUserProfileImg = [tempUserProfileImg stringByReplacingOccurrencesOfString:@"_normal.jpeg" withString:@".jpeg"];
    }
    
    self.userProfileImg = [[NSURL alloc] initWithString:tempUserProfileImg];
    self.userBannerImg = [[NSURL alloc] initWithString:[receivedDict objectForKey:@"profile_banner_url"]];
    return self;
}

@end
