//
//  TweetsDetailsViewController.m
//  TwitterReplica
//
//  Created by Amlaan Bhoi on 7/2/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import "TweetsDetailsViewController.h"
#import "Chameleon.h"
#import "URBMediaFocusViewController.h"

@interface TweetsDetailsViewController () <UIScrollViewDelegate>{
    
    __weak IBOutlet NSLayoutConstraint *constraintImgHeight;
}

@property (weak, nonatomic) IBOutlet UIImageView *tweetImgView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property URBMediaFocusViewController *mediaController;

@end

@implementation TweetsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor flatBlackColorDark];
    [_profileImgView setImageWithURLRequest:[NSURLRequest requestWithURL:_tweetRef.profileImg] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        _profileImgView.image = image;
        _profileImgView.contentMode = UIViewContentModeScaleAspectFill;
        _profileImgView.clipsToBounds = YES;
        _profileImgView.layer.backgroundColor=[[UIColor clearColor] CGColor];
        _profileImgView.layer.cornerRadius=_profileImgView.bounds.size.width/2;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    _screenName.text = _tweetRef.name;
    _userName.text = [[NSString alloc] initWithFormat:@"@%@", _tweetRef.screenName];
    _tweetText.text = _tweetRef.text;
    if (_tweetRef.mediaUrl) {
        [_tweetImgView setImageWithURLRequest:[NSURLRequest requestWithURL:_tweetRef.mediaUrl] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        _tweetImgView.image = image;
        _tweetImgView.contentMode = UIViewContentModeScaleAspectFill;
        _tweetImgView.clipsToBounds = YES;
        _tweetImgView.layer.backgroundColor=[[UIColor clearColor] CGColor];
        _tweetImgView.layer.cornerRadius = _tweetImgView.bounds.size.width * 0.02;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            singleTap.numberOfTapsRequired = 1;
            singleTap.numberOfTouchesRequired = 1;
            [_tweetImgView setUserInteractionEnabled:YES];
            [_tweetImgView addGestureRecognizer:singleTap];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
        }];
    } else {
        constraintImgHeight.constant = 0.0f;
        return;
    }
}

- (void) tapImage: (UITapGestureRecognizer *) singleTap {
    UIImageView *temp = (UIImageView *)singleTap.view;
    self.mediaController = [[URBMediaFocusViewController alloc] init];
    [self.mediaController showImage:temp.image fromView:singleTap.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
