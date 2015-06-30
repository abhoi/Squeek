//
//  TweetsModal.h
//  TwitterReplica
//
//  Created by Vaibhav Kumar on 6/29/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+AFNetworking.h"

@interface TweetsModal : NSObject

@property NSString *createdAt;
@property NSString *text;
@property NSNumber *tweetID;
@property NSNumber *favoriteCount;
@property NSNumber *retweetCount;
@property NSURL *mediaUrl;
@property NSURL *profileImg;
@property NSString *name;
@property NSString *screenName;
@property NSString *combinedName;
@property NSString *timeElapsed;

- (id) initWithData: (NSDictionary *) receivedDict;



@end
