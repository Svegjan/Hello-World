//
//  TwitterDetailViewController.h
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 6/11/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterDetailViewController : UIViewController
@property (nonatomic,strong) IBOutlet UIWebView *webView;
@property (nonatomic,strong) NSString *tweetUrl;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
