//
//  UserProfileModal.h
//  TwitterReplica
//
//  Created by Amlaan Bhoi on 7/2/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfileModal : NSObject

@property NSString *screenName;
@property NSString *userName;
@property NSURL *userProfileImg;
@property NSURL *userBannerImg;
@property NSString *userDescription;
@property NSString *location;
@property NSString *profileURL;
@property NSString *followersCount;
@property NSString *followingCount;
@property NSString *listedCount;
@property NSString *createdAt;
@property NSString *statusesCount;

- (id) initWithData: (NSDictionary *) receivedDict;

@end
