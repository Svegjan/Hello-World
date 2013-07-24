//
//  TwitterFeedViewController.h
//  FTL-Gate
//
//  Created by Vlatko Efremovski on 5/29/13.
//  Copyright (c) 2013 Vlatko Efremovski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "SelectNetworksViewController.h"
#import "TwitterDetailViewController.h"

@interface TwitterFeedViewController : UITableViewController
{
UIView *refreshHeaderView;
UILabel *refreshLabel;
UIImageView *refreshArrow;
UIActivityIndicatorView *refreshSpinner;
BOOL isDragging;
BOOL isLoading;
NSString *textPull;
NSString *textRelease;
NSString *textLoading;
}
@property (nonatomic,strong) ACAccountStore *accountStore;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) NSMutableArray *tweetURL;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) NSMutableArray *tweetAppURL;
@property (strong, nonatomic) TwitterDetailViewController *detailViewController;

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
@end
