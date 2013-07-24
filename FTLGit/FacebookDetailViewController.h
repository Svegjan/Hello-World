//
//  FacebookDetailViewController.h
//  FTL-Gate
//
//  Created by Lion User on 02/06/2013.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacebookDetailViewController : UIViewController
{
    
}
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) IBOutlet UILabel *userName;

@property (strong,nonatomic) NSString *detail;
@property (strong,nonatomic) NSString *profileImageURL;
@property (strong,nonatomic) NSString *comment;

@property (strong,nonatomic) NSString *videoLink;
@property(strong,nonatomic) IBOutlet UIWebView *webView;


@property(nonatomic,strong) IBOutlet UITextView *post;

@property(strong,nonatomic) IBOutlet UIImageView *profileImage;

@property(strong,nonatomic) IBOutlet UIImageView *backGroundImage;

@property(strong,nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(strong,nonatomic) IBOutlet UIImageView *postedImage;

@end
