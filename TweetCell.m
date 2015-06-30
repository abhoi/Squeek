//
//  TweetCell.m
//  TwitterReplica
//
//  Created by Amlaan Bhoi on 6/29/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)feedTweetData:(TweetsModal *)modal
{
    lblTweet.text = modal.text;
    
    if (modal.mediaUrl) {
        [imgPic setImageWithURLRequest:[NSURLRequest requestWithURL:modal.mediaUrl] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            imgPic.image = image;
            imgPic.contentMode = UIViewContentModeScaleAspectFill;
            imgPic.clipsToBounds = YES;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
    }else{
        constraintImgPicHeight.constant = 0.0f;
    }
}


@end
