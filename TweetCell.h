//
//  TweetCell.h
//  TwitterReplica
//
//  Created by Amlaan Bhoi on 6/29/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetsModal.h"
@interface TweetCell : UITableViewCell
{
    __weak IBOutlet UIImageView *imgAuthor;
    
    __weak IBOutlet UIImageView *imgPic;
    __weak IBOutlet UILabel *lblPicUrl;
    __weak IBOutlet UILabel *lblTweet;
}


-(void)feedTweetData:(TweetsModal *)modal;

@end
