//
//  TweetCell.m
//  TwitterReplica
//
//  Created by Amlaan Bhoi on 6/29/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import "TweetCell.h"
#import "Chameleon.h"

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
    imgAuthor.layer.backgroundColor=[[UIColor clearColor] CGColor];
    imgAuthor.layer.cornerRadius=imgAuthor.bounds.size.width/2;
    int verified_temp = [modal.verified intValue];
    if (verified_temp == 1) {
        imgAuthor.layer.borderColor = [[UIColor flatSkyBlueColorDark] CGColor];
    } else {
        imgAuthor.layer.borderColor = [[UIColor flatWhiteColor] CGColor];
    }
    imgAuthor.layer.borderWidth = 2.0;
    imgAuthor.clipsToBounds = YES;
    lblTime.text = modal.timeElapsed;
    lblTweet.text = modal.text;
    lblAuthor.text = modal.combinedName;
    [imgAuthor setImageWithURLRequest:[NSURLRequest requestWithURL:modal.profileImg] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        imgAuthor.image = image;
        imgAuthor.contentMode = UIViewContentModeScaleAspectFit;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
    if (modal.mediaUrl) {
        [imgPic setImageWithURLRequest:[NSURLRequest requestWithURL:modal.mediaUrl] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            imgPic.image = image;
            imgPic.contentMode = UIViewContentModeScaleAspectFill;
            imgPic.clipsToBounds = YES;
            imgPic.layer.cornerRadius = imgPic.bounds.size.width * 0.02;

            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            singleTap.numberOfTapsRequired = 1;
            singleTap.numberOfTouchesRequired = 1;
            [imgPic setUserInteractionEnabled:YES];
            [imgPic addGestureRecognizer:singleTap];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
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
