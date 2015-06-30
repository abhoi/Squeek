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
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [imgPic setUserInteractionEnabled:YES];
        [imgPic addGestureRecognizer:singleTap];
    }else{
        constraintImgPicHeight.constant = 0.0f;
    }
}

- (void) tapImage: (UITapGestureRecognizer *) singleTap {
    UIImageView *temp = (UIImageView *)singleTap.view;
    self.mediaController = [[URBMediaFocusViewController alloc] init];
    [self.mediaController showImage:temp.image fromView:singleTap.view];
}

@end
